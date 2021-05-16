#! /bin/bash
# Battery applet engine

[[ -d /sys/class/power_supply ]] || exit 1

eval BAT=$(gsettings get ydesk.applets bat_dev)
eval AC=$(gsettings get ydesk.applets bat_ac)

AC_STATE=$(< /sys/class/power_supply/$AC/online)

BAT_FULL=$(< /sys/class/power_supply/$BAT/energy_full)
BAT_NOW=$(< /sys/class/power_supply/$BAT/energy_now)
BAT_STATE=$(< /sys/class/power_supply/$BAT/status)

printf -v BAT_PERCENT "%.f" $(echo $BAT_NOW.0 / $BAT_FULL.0 \* 100 | bc -l)

case $BAT_STATE in
    Discharging)
        if [[ $BAT_PERCENT -ge 80 ]]; then
            icon="battery-full"
        elif [[ $BAT_PERCENT -ge 60 ]]; then
            icon="battery-good"
        elif [[ $BAT_PERCENT -ge 40 ]]; then
            icon="battery-low"
        elif [[ $BAT_PERCENT -ge 20 ]]; then
            icon="battery-caution"
        else
            icon="battery-empty"
        fi
        ;;
    Charging)
        if [[ $BAT_PERCENT -ge 80 ]]; then
            icon="battery-full-charging"
        elif [[ $BAT_PERCENT -ge 60 ]]; then
            icon="battery-good-charging"
        elif [[ $BAT_PERCENT -ge 40 ]]; then
            icon="battery-low-charging"
        else
            icon="battery-caution-charging"
        fi
        ;;
    *)
        if [[ $AC_STATE -eq 1 ]]; then
            icon="ac-adapter"
        else
            icon="battery-missing"
        fi
        ;;
esac

isize=$(gsettings get ydesk.panel isize)
echo "SendToModule FvwmPanel Silent ChangeButton bat Icon $(yad-tools --icon --size=$isize $icon)"
