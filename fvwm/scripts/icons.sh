#! /bin/bash
# Update icons used by fvwm

# remove icon cache cache
[[ $1 == -f ]] && rm -rf ${XDG_CACHE_HOME:-$HOME/.share}/ydesk/fvwm/icons

declare -A common=([desk]=emblem-desktop [edit]=accessories-text-editor [media]=drive-removable-media
    [info]=dialog-information [lock]=system-lock-screen [mixer]=multimedia-volume-control
    [prefs]=preferences-system [recent]=document-open-recent [restart]=view-refresh [run]=system-run
    [search]=system-search [shot]=applets-screenshooter [shutdown]=system-shutdown 
    [settings]=preferences-other [sysmon]=utilities-system-monitor [term]=utilities-terminal
    [web]=web-browser [winclose]=window-close [y]=ydesk)

imagedir="${XDG_DATA_HOME:-$HOME/.share}/ydesk/images"
mkdir -p $imagedir

isize=$(gsettings get ydesk.panel isize)
for k in ${!common[@]}; do
    i="$(yad-tools -i -s $isize ${common[$k]})"
    [[ -e $i ]] && ln -sf $i $imagedir/$k.png
done
