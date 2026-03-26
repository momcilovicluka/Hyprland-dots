#!/bin/bash

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals
#
# NOTE: this script is in bash (not posix shell), because the RANDOM variable
# we use is not defined in posix
pywal_script=$HOME/.config/hypr/scripts/PywalSwww.sh
pywal_refresh=$HOME/.config/hypr/scripts/Refresh.sh

if [[ $# -lt 1 ]] || [[ ! -d $1   ]]; then
    echo "Usage:
    $0 <dir containing images>"
    exit 1
fi

# Edit below to control the images transition
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_STEP=2
export AWWW_TRANSITION_FPS=60
export AWWW_TRANSITION_STEP=2
#export SWWW_TRANSITION_TYPE=random

# This controls (in seconds) when to switch to the next image
INTERVAL=60

while true; do
    find "$1" \
    | while read -r img; do
        echo "$((RANDOM % 1000)):$img"
    done \
    | sort -n | cut -d':' -f2- \
    | while read -r img; do
        pkill swaybg
        awww query || awww-daemon&
        awww img "$img" --transition-type any
        ln -sfn "$img" "$HOME/.config/rofi/.current_wallpaper"
        wal -i $img -n
        pywalfox update
        pywal-discord -p /home/luka/.config/VencordDesktop/VencordDesktop/themes/
        cp $HOME/.cache/wal/colors-rofi-dark.rasi $HOME/.config/rofi/pywal-color/pywal-theme.rasi
        # for cava-pywal (note, need to manually restart cava once wallpaper changes)
        ln -sf "$HOME/.cache/wal/cava-colors" "$HOME/.config/cava/config" || true
        $pywal_script "$img"
        $pywal_refresh
        sleep $INTERVAL
    done
done_command="rofi -show -dmenu -config ~/.config/rofi/config-wallpaper.rasi"

menu() {
    # Here we are looping in the PICS array that is composed of all images in the $DIR folder
    for i in ${!PICS[@]}; do
        # keeping the .gif to make sue you know it is animated
        if [[ -z $(echo ${PICS[$i]} | grep .gif$) ]]; then
            printf "$i. $(echo ${PICS[$i]} | cut -d. -f1)\x00icon\x1f${DIR}/${PICS[$i]}\n" # n°. <name_of_file_without_identifier>
        else
            printf "$i. ${PICS[$i]}\n"
        fi
    done
    
    printf "$RANDOM_PIC_NAME"
}

awww query || awww-daemon &

main() {
    #choice=$(menu | ${wofi_command})
    choice=$(menu | ${rofi_command})
    
    # no choice case
    if [[ -z $choice ]]; then return; fi
    
    # random choice case
    if [ "$choice" = "$RANDOM_PIC_NAME" ]; then
        awww img ${DIR}/${RANDOM_PIC} $SWWW_PARAMS
        ln -sfn "${DIR}/${RANDOM_PIC}" "$HOME/.config/rofi/.current_wallpaper"
        $pywal_script "${DIR}/${RANDOM_PIC}"
        $pywal_refresh
        return
    fi
    
    pic_index=$(echo $choice | cut -d. -f1)
    awww img ${DIR}/${PICS[$pic_index]} $SWWW_PARAMS
    ln -sfn "${DIR}/${PICS[$pic_index]}" "$HOME/.config/rofi/.current_wallpaper"
    # for cava-pywal (note, need to manually restart cava once wallpaper changes)
    ln -sf "$HOME/.cache/wal/cava-colors" "$HOME/.config/cava/config" || true
    $pywal_script "${DIR}/${PICS[$pic_index]}"
    $pywal_refresh
}

# Check if rofi is already running
if pidof rofi >/dev/null; then
    pkill rofi
    exit 0
fi

main

# Uncomment to launch something if a choice was made
# if [[ -n "$choice" ]]; then
# Restart Waybar
# fi
