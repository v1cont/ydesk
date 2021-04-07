SUBDIRS = 16x16 24x24 32x32 48x48 64x64 96x96 scalable

themedir = $(datadir)/icons/Y
theme_DATA = index.theme

gtk_update_icon_cache = gtk-update-icon-cache -f -t $(themedir)

install-data-hook:
	@-if test -z "$(DESTDIR)"; then					\
		echo "Updating Gtk icon cache.";			\
		$(gtk_update_icon_cache);				\
	else								\
		echo "*** Icon cache not updated. Remember to run:";	\
		echo "***";						\
		echo "***   $(gtk_update_icon_cache)";			\
		echo "***";						\
	fi

uninstall-local:
	rm -f $(DESTDIR)$(themedir)/icon-theme.cache;
