dnl Process this file with autoconf to produce a configure script.

AC_INIT([ydesk],[0.90],[victor@sanana.kiev.ua],[ydesk],[http://sanana.kiev.ua/ydesk/])
AC_CONFIG_AUX_DIR([build])

AM_INIT_AUTOMAKE(1.11 foreign subdir-objects dist-xz no-dist-gzip)
AM_SILENT_RULES([yes])

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_SRCDIR([.])

AC_CONFIG_MACRO_DIR([m4])

AM_MAINTAINER_MODE

AC_PROG_CC
AM_PROG_CC_STDC
AC_HEADER_STDC

AM_PROG_CC_C_O

GLIB_GSETTINGS

PKG_CHECK_MODULES([GTK], [gtk+-3.0 >= 3.24.0])
AC_SUBST([GTK_CFLAGS])
AC_SUBST([GTK_LIBS])

dnl ---------------------------------------------------
dnl Utilities
dnl ---------------------------------------------------

AC_PATH_PROG([BASH], [bash])
AC_PATH_PROG([YAD], [yad])

dnl ---------------------------------------------------
dnl Optional features
dnl ---------------------------------------------------

AC_ARG_WITH([icons],
    [AS_HELP_STRING([--with-icons=THEME,...],[add fallback icon themes (default - mate,Adwaita,hicolor)])],
    [FALLBACK_ICONS=$withval], [FALLBACK_ICONS=mate,Adwaita,hicolor])
AC_SUBST(FALLBACK_ICONS)

dnl ---------------------------------------------------
dnl i18n
dnl ---------------------------------------------------

IT_PROG_INTLTOOL([0.40.0])

INTLTOOL_CONF_RULE='%.conf: %.conf.in $(INTLTOOL_MERGE) $(wildcard $(top_srcdir)/po/*.po) ; LC_ALL=C $(INTLTOOL_MERGE) -d -u -c $(top_builddir)/po/.intltool-merge-cache $(top_srcdir)/po $< [$]@'
_IT_SUBST(INTLTOOL_CONF_RULE)

GETTEXT_PACKAGE=ydesk
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE, "$GETTEXT_PACKAGE", [Gettext package])

AM_GLIB_GNU_GETTEXT

dnl Generate output

AC_CONFIG_LINKS([
settings/ysettings.sh:settings/ysettings.in
utils/ydentry.sh:utils/ydentry.in
utils/yfind.sh:utils/yfind.in
utils/yimage.sh:utils/yimage.in
utils/ylogout.sh:utils/ylogout.in
utils/ymedia.sh:utils/ymedia.in
utils/ymixer.sh:utils/ymixer.in
utils/ypass.sh:utils/ypass.in
utils/yps.sh:utils/yps.in
utils/yrun.sh:utils/yrun.in
utils/ysysinfo.sh:utils/ysysinfo.in
utils/yterm.sh:utils/yterm.in
utils/ywget.sh:utils/ywget.in
utils/ywifi.sh:utils/ywifi.in
])

AC_CONFIG_FILES([
Makefile
fvwm/Makefile
fvwm/scripts/clipman.sh
fvwm/scripts/mail.sh
fvwm/scripts/media.sh
fvwm/scripts/notes.sh
fvwm/scripts/shot.sh
fvwm/scripts/weather.sh
fdo/Makefile
settings/Makefile
settings/ysettings
settings/desktop.sh
settings/interface.sh
settings/mime.sh
settings/panel.sh
settings/printer.sh
settings/session.sh
settings/term.sh
settings/panel/Makefile
settings/panel/bat.sh
settings/panel/clock.sh
settings/panel/cpu.sh
settings/panel/mail.sh
settings/panel/menu.sh
settings/panel/run.sh
settings/panel/shot.sh
settings/panel/sysinfo.sh
settings/panel/taskbar.sh
settings/panel/volume.sh
settings/panel/weather.sh
settings/panel/wifi.sh
utils/Makefile
utils/ydentry
utils/yfind
utils/yimage
utils/ylogout
utils/ymedia
utils/ymixer
utils/ynotify
utils/ypass
utils/yps
utils/yrun
utils/ysession
utils/ysysinfo
utils/yterm
utils/ywget
utils/ywifi
data/Makefile
data/icons/Makefile
data/icons/16x16/Makefile
data/icons/16x16/apps/Makefile
data/icons/16x16/categories/Makefile
data/icons/16x16/devices/Makefile
data/icons/16x16/status/Makefile
data/icons/24x24/Makefile
data/icons/24x24/apps/Makefile
data/icons/24x24/categories/Makefile
data/icons/24x24/devices/Makefile
data/icons/24x24/status/Makefile
data/icons/32x32/Makefile
data/icons/32x32/apps/Makefile
data/icons/32x32/categories/Makefile
data/icons/32x32/devices/Makefile
data/icons/32x32/status/Makefile
data/icons/48x48/Makefile
data/icons/48x48/apps/Makefile
data/icons/48x48/categories/Makefile
data/icons/48x48/devices/Makefile
data/icons/48x48/status/Makefile
data/fdo/Makefile
data/fdo/notification.service
data/menu/Makefile
data/menu/desktop-directories/Makefile
data/misc/Makefile
data/settings/Makefile
data/theme/Makefile
data/theme/gtk-3.0/Makefile
data/theme/icons/Makefile
data/theme/icons/index.theme
data/theme/icons/16x16/Makefile
data/theme/icons/16x16/actions/Makefile
data/theme/icons/24x24/Makefile
data/theme/icons/24x24/actions/Makefile
data/theme/icons/32x32/Makefile
data/theme/icons/32x32/actions/Makefile
data/theme/icons/48x48/Makefile
data/theme/icons/48x48/actions/Makefile
data/theme/icons/64x64/Makefile
data/theme/icons/64x64/actions/Makefile
data/theme/icons/96x96/Makefile
data/theme/icons/96x96/actions/Makefile
data/theme/icons/scalable/Makefile
data/theme/icons/scalable/actions/Makefile
data/utils/Makefile
po/Makefile.in
])
AC_OUTPUT
