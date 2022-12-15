#! /bin/bash
# Volume control

function slider {
     vol=$(amixer sget $SCTRL | tail -n 1 | sed -r 's/.*\[([0-9]+)\%\].*/\1/')
     yad --scale --vertical --close-on-unfocus --undecorated --mouse --on-top \
         --skip-taskbar --height=200 --no-buttons \
         --print-partial --page=5 --value=$vol | while read v; do
         amixer -q sset $SCTRL ${v}%
     done
}

eval SCTRL=$(gsettings get ydesk.applets vol_ctl)
export SCTRL

upd=0
case $1 in
    inc) amixer -q sset $SCTRL 2%+ ;;
    dec) amixer -q sset $SCTRL 2%- ;;
    mute) amixer -q sset $SCTRL toggle mute ;;
    vol) slider ;;
    show) ymixer ;;
    upd) upd=1 ;;
esac

vol=$(amixer sget $SCTRL | tail -n 1 | sed -r 's/.*\[([0-9]+)\%\].*/\1/')
if [[ $1 == inc || $1 == dec ]]; then
    # show on-screen volume meter
    osd_cat -b percentage -p middle -A center -P $vol -d 1 -c darkgreen
fi
if [[ $vol -ge 75 ]]; then
    icon="audio-volume-high"
elif [[ $vol -ge 35 ]]; then
    icon="audio-volume-medium"
elif [[ $vol -ge 0 ]]; then
    icon="audio-volume-low"
else
    icon="audio-volume-muted"
fi

isize=$(gsettings get ydesk.panel isize)
if [[ $upd -eq 0 ]]; then
    exec FvwmCommand "SendToModule FvwmPanel Silent ChangeButton volume Icon $(yad-tools --icon --size=$isize $icon)"
else
    echo "SendToModule FvwmPanel Silent ChangeButton volume Icon $(yad-tools --icon --size=$isize $icon)"
fi
