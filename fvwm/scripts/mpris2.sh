#! /bin/bash
# -*- mode: sh -*-
#
# MPRIS2 client
# Author: Victor Ananjevsky <ananasik@gmail.com>, 2023
#

trap "rm -f /tmp/ydesk-mpris2.*" EXIT

eval player=$(gsettings get ydesk.apps player)

case $1 in
    play|pause)
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$player /org/mpris/MediaPlayer2 \
                  org.mpris.MediaPlayer2.Player.PlayPause &> /dev/null
        # set status
        dbus-send --print-reply --type=method_call --dest=org.mpris.MediaPlayer2.$player /org/mpris/MediaPlayer2 \
                  org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' |\
            awk '/string/ {print $3}' > /tmp/ydesk-mpris2.state
        if [[ $(< /tmp/ydesk-mpris2.state) == "Playing" ]]; then
            icon="pause"
        else
            icon="play"
        fi
        FvwmCommand "SendToModule FvwmPanel Silent ChangeButton mpris_play Icon $icon"
        ;;
    stop)
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$player /org/mpris/MediaPlayer2 \
                  org.mpris.MediaPlayer2.Player.Stop &> /dev/null
        ;;
    next)
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$player /org/mpris/MediaPlayer2 \
                  org.mpris.MediaPlayer2.Player.Next &> /dev/null
        ;;
    prev)
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$player /org/mpris/MediaPlayer2 \
                  org.mpris.MediaPlayer2.Player.Previous &> /dev/null
        ;;
    info)
        # this code from https://gitlab.com/axdsop/nix-dotfiles/tree/master/Configs/polybar/scripts/mpris_player
        dbus-send --print-reply --type=method_call --dest=org.mpris.MediaPlayer2.$player /org/mpris/MediaPlayer2 \
                  org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' |\
            sed -r -n '/variant.*array/d; /(string[[:space:]]+|variant[[:space:]]+)/!d; /".*"$/{s@[^"]+"(.*?)"[^"]*$@\1@g}; /variant/{s@.*[[:space:]]+@@g}; p' |\
            sed 's@:@|@g;N;s@\n@|@g' > /tmp/ydesk-mpris2.info
        artist=$(awk -F'|' '/artist/ {print $3}' /tmp/ydesk-mpris2.info)
        title=$(awk -F'|' '/title/ {print $3}' /tmp/ydesk-mpris2.info)
        ynotify -t 300 -i applications-multimedia "$artist" "$artist - $title"
        ;;
esac
