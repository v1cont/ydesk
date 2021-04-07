#! /bin/bash
# make a screenshot

TEXTDOMAIN=ydesk
TEXTDOMAINDIR=/usr/share/locale

export ifile=$(mktemp -u --tmpdir=/tmp/ydesk shot-XXXXXXXX.png)

trap "rm -f $ifile" EXIT

function save_file
{
    idir="$(xdg-user-dir PICTURES)/screenshots"
    mkdir -p "$idir"
    ofile=$(yad --title=$"Save screenshot" --width=500 --height=400 \
                --file --save --filename="$idir/screenshot-$EPOCHSECONDS.png")
    [[ -n $ofile ]] && mv -f $ifile $ofile
}
export -f save_file

function copy_file
{
    xclip -selection primary -target image/png -i $ifile
}
export -f copy_file

case $1 in
    root) xrefresh && gm import -window root $ifile ;;
    reg) xrefresh && gm import -frame $ifile ;;
    *) exit 1 ;;
esac

if [[ -e $ifile ]]; then
    yad --title=$"Screenshot" --width=500 --height=400 \
        --window-icon="applets-screenshooter" \
        --button=$"Clipboard!yad-paste:bash -c copy_file" \
        --button="yad-save:bash -c save_file" \
        --button="yad-close:0" \
        --picture --size=fit --filename="$ifile"
fi
