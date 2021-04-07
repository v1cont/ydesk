#! /bin/bash

if [[ $1 == cal ]]; then
    xlsclients | grep -q FVWM-Cal || exec yad --name=FVWM-Cal \
        --undecorated --close-on-unfocus --posx="-10" --posy="45" \
        --no-buttons --skip-taskbar --calendar
fi

tm="$(date +'%R')"
dt="$(date +'%A, %d %B %Y')"

echo "SendToModule FvwmPanel Silent ChangeButton clock Title \"$tm\", TipsLabel \"$dt\""
