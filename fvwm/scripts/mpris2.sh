#! /bin/bash
# -*- mode: sh -*-
#
# MPRIS2 client
# Author: Victor Ananjevsky <ananasik@gmail.com>, 2023
#

eval player=$(gsettings get ydesk.apps player)

case $1 in
    play|pause) 
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$player /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause &> /dev/null
        ;;
    stop)
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$player /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop &> /dev/null
        ;;
    next)
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$player /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next &> /dev/null
        ;;
    prev)
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$player /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous &> /dev/null
        ;;
esac
