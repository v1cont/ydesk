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
All required patches can be found in https://github.com/v1cont/patches/tree/master/fvwm3
