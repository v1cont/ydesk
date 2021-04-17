This is a simple desktop based on *Fvwm3*. 
It includes a complex Fvwm3 configuration and several scripts for configuration and miscellaneous purposes.

External software needed by Ydesk:
- *Bash* and *YAD* - almost all scripts needs this
- *Pyhton3* and *pygobject* - needed for menu generator and notification daemon
- *curl* - needed for mail and weather panel applets
- *libsecret* and *secret-tool* - used as a credential storage for mail applet
- *stalonetray* - used in system tra panel applet
- *xxkb* - used as keyboard indicator and switcher
- *conky* - used in sysinfo applet
- *GraphicsMagick* - used in screenshot applet
- *jq* - used for parsing weather forecast
- *xdotool* - for some window manipulations
- *wpa_supplicant* - used in wifi applet
- *mate-icon-theme* is strongly recommended

Ydesk uses patched version of Fvwm3.
All required patches located in misc/ directory.

List of patches:
- fvwm-borders.patch -- add small border under window title
- fvwm-datadir.patch -- add ability to specify system fvwm directory with $FVWM_DATADIR in addition to compiled-in path
- fvwm-iconman.patch -- some tweaks to FvwmIconMan module
- fvwm-menusep.patch -- add flat look of menu separators
- fvwm-pager.patch -- use right mouse button instead of middle to move windows across a pager
- fvwm-tips.patch -- add tips to FvwmButtons (this patch is not working right and must be fixed in a future)
- intltool-fvwm.patch -- add support of gettext in fvwm config for intltools
