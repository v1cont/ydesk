#! /bin/bash
# Create quicklaunch panel applet

isize=$(gsettings get ydesk.panel isize)

qldir="${XDG_DATA_HOME:-$HOME/.share}/ydesk/qlaunch/"
mkdir -p "$qldir"

echo "*FvwmPanel: (1x1)"
for f in $(find "$qldir" -type f -name "*.desktop"); do
    eval $(grep -E '^[[:blank:]]*(Icon|Name|Exec)=' "$f" | sed -r 's/=(.*)$/="\1"/')
    ficon=$(yad-tools --icon --size=$isize ${Icon:-system-run})
    echo "*FvwmPanel: (25x1, Padding 2 2, ActiveColorset 2, Icon \"$ficon\", TipsLabel \"$Name\", Action Exec exec ${Exec%% \%*})"
    unset Icon Name Exec ficon
done
echo "*FvwmPanel: (1x1)"
