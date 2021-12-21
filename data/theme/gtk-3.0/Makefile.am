themedir = $(datadir)/themes/Y/gtk-3.0
theme_DATA = gtk.css gtk.gresource

gtk.gresource:
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) $@.xml

EXTRA_DIST = gtk.css gtk-main.css gtk-colors.css gtk-widgets.css gtk-apps.css gtk.gresource.xml

DISTCLEANFILES = gtk.gresource
