#! /bin/bash
# create panel

eval ENABLE=$(gsettings get ydesk.panel enable)
[[ $ENABLE == false ]] && exit 0

eval POS=$(gsettings get ydesk.panel pos)
if [[ $POS == bottom ]]; then
    echo "EwmhBaseStruts 0 0 0 27"
else
    echo "EwmhBaseStruts 0 0 27 0"
fi

isize=$(gsettings get ydesk.panel isize)
echo "InfoStoreAdd p_clock '$(date +%R)'"
echo "InfoStoreAdd p_battery $(yad-tools --icon --size=$isize battery-missing)"
echo "InfoStoreAdd p_media $(yad-tools --icon --size=$isize drive-removable-media)"
echo "InfoStoreAdd p_mail $(yad-tools --icon --size=$isize nomail)"
echo "InfoStoreAdd p_vol $(yad-tools --icon --size=$isize audio-volume-muted)"
echo "InfoStoreAdd p_wifi $(yad-tools --icon --size=$isize nm-signal-00)"
echo "InfoStoreAdd p_wthr $(yad-tools --icon --size=$isize weather-overcast)"

eval APPLETS=($(gsettings get ydesk.panel applets | sed "s/,/ /g"))

# load config
for a in ${APPLETS[@]}; do
    if [[ $a == sep* ]]; then
        sz=${a:3}
        echo "*FvwmPanel: (${sz:-1}x1)"
    else
        [[ -e $FVWM_DATADIR/applets/$a.fvwm ]] && grep -v "^#" $FVWM_DATADIR/applets/$a.fvwm
    fi
done
