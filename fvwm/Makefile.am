AM_CPPFLAGS = -DLOCALEDIR=\""$(datadir)/locale"\"

fvwmdir = $(datadir)/ydesk/fvwm
dist_fvwm_DATA = config/colors.fvwm config/decor.fvwm config/functions.fvwm \
                 config/keys.fvwm config/main.fvwm config/menus.fvwm config/modules.fvwm

appletdir = $(fvwmdir)/applets
dist_applet_DATA = config/applets/bat.fvwm config/applets/clock.fvwm config/applets/cpu.fvwm \
                   config/applets/desk.fvwm config/applets/kbd.fvwm config/applets/leds.fvwm \
                   config/applets/menu.fvwm config/applets/pager.fvwm config/applets/qlaunch.fvwm \
                   config/applets/shot.fvwm config/applets/sysinfo.fvwm config/applets/tray.fvwm \
                   config/applets/taskbar.fvwm config/applets/media.fvwm config/applets/volume.fvwm \
                   config/applets/xeyes.fvwm config/applets/run.fvwm config/applets/mail.fvwm \
                   config/applets/wact.fvwm config/applets/wifi.fvwm config/applets/weather.fvwm

imagedir = $(fvwmdir)/images
dist_image_DATA = images/min.png images/max.png images/check.png images/close.png images/side.png images/default.png

flib_files = scripts/ymenu.py scripts/panel.sh scripts/qlaunch.sh scripts/infostore.sh scripts/icons.sh \
             scripts/clock.sh scripts/volume.sh scripts/battery.sh scripts/prun.sh scripts/wifi.sh

flibdir = $(libdir)/ydesk/fvwm
flib_SCRIPTS = $(flib_files) scripts/clipman.sh scripts/shot.sh scripts/media.sh \
			   scripts/weather.sh scripts/mail.sh

flib_PROGRAMS = ycpu

ycpu_SOURCES = cpu.c
ycpu_CFLAGS = $(GTK_CFLAGS)
ycpu_LDADD = $(GTK_LIBS) $(INTLLIBS)

EXTRA_DIST = $(flib_files)
