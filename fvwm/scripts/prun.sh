#! /bin/bash
# -*- mode: sh -*-

TRM=${XTERM:-xterm}

while : ; do
    read cmd
    echo -ne '\ec'
    # run command
    export cmd
    ( case $cmd in
        http://*|https://*|ftp://*|file://*) xdg-open $cmd ;;
        mailto://*) xdg-email $cmd ;;
        man://*) $TRM -e man ${cmd:6} ;;
        telnet |ssh |man ) $TRM -e $cmd ;;
        t:*) $TRM -e ${cmd:2} ;;
        *) $cmd ;;
      esac ) &> /dev/null &
done
