
desktopdir = $(datadir)/applications
desktop_in_files = yps.desktop.in yfind.desktop.in ysysinfo.desktop.in \
				   yimage.desktop.in yman.desktop.in ywifi.desktop.in
desktop_DATA = $(desktop_in_files:.desktop.in=.desktop)

xsessiondir = $(datadir)/xsessions
xsession_in_files = ysession.desktop.in
xsession_DATA = $(xsession_in_files:.desktop.in=.desktop)

@INTLTOOL_DESKTOP_RULE@

EXTRA_DIST = $(desktop_in_files) $(xsession_in_files)
DISTCLEANFILES = $(desktop_DATA) $(xsession_DATA)
