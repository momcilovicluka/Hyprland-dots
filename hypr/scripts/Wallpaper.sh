#!/bin/bash

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals

pywal_script=$HOME/.config/hypr/scripts/PywalSwww.sh
pywal_refresh=$HOME/.config/hypr/scripts/Refresh.sh

if [[ $# -lt 1 ]] || [[ ! -d $1   ]]; then
    echo "Usage:
    $0 <dir containing images>"
    exit 1
fi

# Edit below to control the images transition
export AWWW_TRANSITION_FPS=60
export AWWW_TRANSITION_STEP=2
export AWWW_TRANSITION_TYPE=random

# This controls (in seconds) when to switch to the next image
INTERVAL=300

while true; do
    find "$1" \
    | while read -r img; do
        echo "$((RANDOM % 1000)):$img"
    done \
    | sort -n | cut -d':' -f2- \
    | while read -r img; do
        swww img "$img" && ln -sfn "$img" "$HOME/.config/rofi/.current_wallpaper" && $pywal_script "$img" && $pywal_refresh
        # for cava-pywal (note, need to manually restart cava once wallpaper changes)
        # ln -sf "$HOME/.cache/wal/cava-colors" "$HOME/.config/cava/config" || true
        sleep $INTERVAL
        
    done
done

    change_swww
    fi
}

switch(){
    if pidof swaybg >/dev/null; then
        change_swww
    else
        change_swaybg
    fi
}

case "$1" in
    "swaybg")
        change_swaybg
    ;;
    "swww")
        change_swww
    ;;
    "awww")
        change_swww
    ;;
    "s")
        switch
    ;;
    *)
        change_current
    ;;
esac