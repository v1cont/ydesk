/*
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <sys/time.h>
#include <sys/sysinfo.h>
#include <time.h>
#include <stdlib.h>
#include <strings.h>

#include <gtk/gtk.h>
#include <glib/gi18n.h>

#define WIDTH  50
#define HEIGHT 20

typedef struct {
  guint64 u, n, s, i;             /* User, nice, system, idle */
} cpu_stat_t;

typedef struct {
  GtkWidget *ev;
  GtkWidget *da;
  cairo_surface_t *pixmap;

  GString *tip;

  cpu_stat_t st;

  float *stats;
  gint s_cur;

  GdkRGBA fore;
  GdkRGBA back;

  gint n_cpu;
  guint width;
  guint height;

  gboolean mem;
} cpu_data_t;

/* draw chart */
static void
cpu_redraw_pixmap (cpu_data_t *cp)
{
  gint i, si = cp->s_cur;
  cairo_t *cr = cairo_create (cp->pixmap);

  cairo_set_line_width (cr, 1.0);

  /* Erase pixmap. */
  cairo_rectangle (cr, 0, 0, cp->width, cp->height);
  gdk_cairo_set_source_rgba (cr, &cp->back);
  cairo_fill (cr);

  /* Recompute pixmap. */
  gdk_cairo_set_source_rgba (cr, &cp->fore);
  for (i = 0; i < cp->width; i++)
    {
      /* Draw one bar of the CPU usage graph. */
      if (cp->stats[si] != 0.0)
        {
          cairo_move_to (cr, (gdouble) i, (gdouble) cp->height);
          cairo_line_to (cr, (gdouble) i, (gdouble) cp->height - cp->stats[si] * cp->height);
          cairo_stroke (cr);
        }

      si--;
      if (si < 0)
        si = cp->width - 1;
    }

  /* Redraw pixmap. */
  gtk_widget_queue_draw(cp->da);
}

static void
get_mem_usage (GString *tip)
{
  FILE *stat;

  /* get memory usage */
  if ((stat = fopen ("/proc/meminfo", "r")) != NULL)
    {
      guint64 mem_total = 0;
      guint64 mem_free = 0;
      guint64 mem_cached = 0;
      guint64 mem_buffered = 0;

      guint64 swap_total = 0;
      guint64 swap_free = 0;

      gchar *su, *st, buf[1024];

      gint reach = 0;

      while (fgets (buf, 100, stat) != NULL)
        {
          if (!strncmp (buf, "MemTotal:", 9))
            mem_total = atoi (buf + 10), reach++;
          else if (!strncmp (buf, "MemFree:", 8))
            mem_free = atoi (buf + 9), reach++;
          else if (!strncmp (buf, "Cached:", 7))
            mem_cached += atoi (buf + 8), reach++;
          else if (!strncmp (buf, "SReclaimable:", 13))
            mem_cached += atoi (buf + 14), reach++;
          else if (!strncmp (buf, "Bufs:", 8))
            mem_buffered = atoi (buf + 9), reach++;
          else if (!strncmp (buf, "SwapTotal:", 10))
            swap_total = atoi (buf + 11), reach++;
          else if (!strncmp (buf, "SwapFree:", 9))
            swap_free = atoi (buf + 10), reach++;
          if (reach == 7)
            break;
        }
      fclose (stat);

      /* append to tip string */
      su = g_format_size ((mem_total - mem_free - mem_cached -mem_buffered) * 1024);
      st = g_format_size (mem_total * 1024);
      g_string_append_printf (tip, _("\nMemory usage: %s / %s"), su, st);
      g_free (st);
      g_free (su);

      su = g_format_size ((swap_total - swap_free) * 1024);
      st = g_format_size (swap_total * 1024);
      g_string_append_printf (tip, _("\nSwap usage: %s / %s"), su, st);
      g_free (st);
      g_free (su);
    }
}

static volatile gboolean update_lock = FALSE;

/* Periodic timer callback. */
static gboolean
cpu_update (cpu_data_t *cp)
{
  if (update_lock)
    return TRUE;

  update_lock = TRUE;

  if ((cp->stats != NULL) && (cp->pixmap != NULL))
    {
      /* Open statistics file and scan out CPU usage. */
      cpu_stat_t cpu;
      FILE *stat;
      gchar *tmpl, buf[4096];
      gint offset, res = 0;

      if ((stat = fopen ("/proc/stat", "r")) == NULL)
        return TRUE;

      if (cp->n_cpu == -1)
        tmpl = g_strdup ("cpu ");
      else
        tmpl = g_strdup_printf ("cpu%d ", cp->n_cpu);
      offset = strlen (tmpl);

      while (!feof (stat))
        {
          fgets (buf, 4096, stat);
          if (strncmp (buf, tmpl, offset) == 0)
            {
              res = sscanf (buf + offset, "%llu %llu %llu %llu", &cpu.u, &cpu.n, &cpu.s, &cpu.i);
              break;
            }
        }
      fclose(stat);

      g_free (tmpl);

      /* Ensure that fscanf succeeded. */
      if (res == 4)
        {
          /* Compute delta from previous statistics. */
          cpu_stat_t cpu_delta;
          float cpu_uns;

          cpu_delta.u = cpu.u - cp->st.u;
          cpu_delta.n = cpu.n - cp->st.n;
          cpu_delta.s = cpu.s - cp->st.s;
          cpu_delta.i = cpu.i - cp->st.i;

          /* Copy current to previous. */
          memcpy (&cp->st, &cpu, sizeof (cpu_stat_t));

          /* Compute user+nice+system as a fraction of total.
           * Introduce this sample to ring buffer, increment and wrap ring buffer cursor. */
          cpu_uns = cpu_delta.u + cpu_delta.n + cpu_delta.s;

          cp->s_cur++;
          if (cp->s_cur >= cp->width)
            cp->s_cur = 0;
          cp->stats[cp->s_cur] = cpu_uns / (cpu_uns + cpu_delta.i);

          cpu_redraw_pixmap (cp);

          /* set tooltip */
          if (cp->n_cpu == -1)
            g_string_printf (cp->tip, _("CPU Load - %d%%"), (gint) (cp->stats[cp->s_cur] * 100));
          else
            g_string_printf (cp->tip, _("CPU%d Load - %d%%"), cp->n_cpu, (gint) (cp->stats[cp->s_cur] * 100));

          if (cp->mem)
            get_mem_usage (cp->tip);

          gtk_widget_set_tooltip_markup (cp->ev, cp->tip->str);
        }
    }

  update_lock = FALSE;

  return TRUE;
}

static gboolean
cpu_cfg_cb (GtkWidget *w, GdkEventConfigure *ev, cpu_data_t *cp)
{
  GtkAllocation al;

  gtk_widget_get_allocation (w, &al);

  /* Allocate or reallocate pixmap. */
  cp->height = MAX (al.height, HEIGHT);
  cp->width = MAX (al.width, WIDTH);

  cp->stats = g_renew (float, cp->stats, cp->width);
  bzero (cp->stats, cp->width);
  cp->s_cur = cp->width;

  if (cp->pixmap)
    cairo_surface_destroy (cp->pixmap);
  cp->pixmap = cairo_image_surface_create (CAIRO_FORMAT_RGB24, cp->width, cp->height);

  /* Redraw pixmap at the new size. */
  cpu_redraw_pixmap (cp);

  return TRUE;
}

static gboolean
cpu_draw_cb (GtkWidget *w, cairo_t *cr, cpu_data_t *cp)
{
  if (cp->pixmap)
    {
      cairo_set_source_rgb (cr, 0, 0, 0);
      cairo_set_source_surface (cr, cp->pixmap, 0, 0);
      cairo_paint (cr);
    }

  return FALSE;
}

int
main (int argc, char *argv[])
{
  cpu_data_t *cp;
  GtkWidget *win;

  gint n_cpu = -1;
  guint width = WIDTH;
  guint period;

  GSettings *settings;

  GOptionEntry opts[] = {
    { "width", 'w', 0, G_OPTION_ARG_INT, &width, N_("Set window width"), N_("WIDTH") },
    { "cpu", 'c', 0, G_OPTION_ARG_INT, &n_cpu, N_("Set CPU number"), N_("NUM") },
    { NULL }
  };

#ifdef ENABLE_NLS
  bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
  bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
  textdomain (GETTEXT_PACKAGE);
#endif

  gtk_init_with_args (&argc, &argv, _("- CPU load monitor"), opts, GETTEXT_PACKAGE, NULL);

  settings = g_settings_new ("ydesk.cpu");

  /* set defaults */
  cp = g_new0 (cpu_data_t, 1);
  cp->width = width;
  cp->n_cpu = n_cpu;
  cp->tip = g_string_new (NULL);

  cp->mem = g_settings_get_boolean (settings, "mem");

  gdk_rgba_parse (&cp->fore, g_settings_get_string (settings, "fg"));
  gdk_rgba_parse (&cp->back, g_settings_get_string (settings, "bg"));

  cp->stats = g_new0 (float, cp->width);

  win = gtk_window_new (GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title (GTK_WINDOW (win), "YCPU");

  cp->ev = gtk_event_box_new ();
  gtk_container_add (GTK_CONTAINER (win), cp->ev);

  cp->da = gtk_drawing_area_new ();
  gtk_widget_set_size_request (cp->da, cp->width, HEIGHT);
  gtk_container_add (GTK_CONTAINER (cp->ev), cp->da);

  g_signal_connect (G_OBJECT (win), "delete-event", G_CALLBACK (gtk_main_quit), NULL);
  g_signal_connect (G_OBJECT (cp->da), "configure-event", G_CALLBACK (cpu_cfg_cb), cp);
  g_signal_connect (G_OBJECT (cp->da), "draw", G_CALLBACK (cpu_draw_cb), cp);

  gtk_widget_show_all (win);
  cpu_update (cp);

  period = g_settings_get_int (settings, "period");
  g_timeout_add (period, (GSourceFunc) cpu_update, (gpointer) cp);

  gtk_main ();

  return 0;
}
