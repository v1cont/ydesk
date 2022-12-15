
bin_SCRIPTS = ysession ynotify yterm yps yrun ylogout yfind yimage yman ymixer ysysinfo ywifi

miscdir = $(libdir)/ydesk/misc
misc_SCRIPTS = ydentry ymedia ywget ypass

install-exec-hook:
	$(LN_S) -f ynotify$(EXEEXT) $(DESTDIR)$(bindir)/notify-send
