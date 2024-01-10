#! /bin/bash
# Wifi applet engine

eval iface=$(gsettings get ydesk.panel.applets wifi_iface)

function wifi_upd {
    eval $(wpa_cli -i ${iface:-wlan0} signal_poll | grep "^RSSI")

    if [[ -n $RSSI ]]; then
        if [[ $RSSI -le -100 ]]; then
            QUALITY=0
        elif [[ $RSSI -ge -50 ]]; then
            QUALITY=100
        else
            QUALITY=$((2 * ($RSSI + 100)))
        fi

        if [[ $QUALITY -gt 75 ]]; then
            icon="nm-signal-100"
        elif [[ $QUALITY -gt 50 ]]; then
            icon="nm-signal-75"
        elif [[ $QUALITY -gt 50 ]]; then
            icon="nm-signal-75"
        elif [[ $QUALITY -gt 25 ]]; then
            icon="nm-signal-50"
        elif [[ $QUALITY -gt 10 ]]; then
            icon="nm-signal-25"
        else
            icon="nm-signal-00"
        fi
    else
        icon="nm-signal-00"
    fi

    isize=$(gsettings get ydesk.panel isize)
    echo "SendToModule FvwmPanel Silent ChangeButton wifi Icon $(yad-tools --icon --size=$isize $icon)"
}

case $1 in
    ctrl|control) ywifi -i $iface ;;
    *) wifi_upd ;;
esac
