desktopdir = $(datadir)/applications
desktop_in_files = ysettings.desktop.in
desktop_DATA = $(desktop_in_files:.desktop.in=.desktop)

confdir = $(datadir)/settings
conf_in_files = desk.desktop.in mime.desktop.in panel.desktop.in printer.desktop.in sound.desktop.in interface.desktop.in session.desktop.in term.desktop.in
conf_DATA = $(conf_in_files:.desktop.in=.desktop)

@INTLTOOL_DESKTOP_RULE@

EXTRA_DIST = $(desktop_in_files) $(conf_in_files)
DISTCLEANFILES = $(desktop_DATA) $(conf_DATA)
