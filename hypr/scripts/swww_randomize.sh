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
  			swww query || swww init
			swww img "$img" --transition-type any
			wal -i $img -n
			pywalfox update
			pywal-discord -p /home/luka/.config/VencordDesktop/VencordDesktop/themes/
			cp $HOME/.cache/wal/colors-rofi-dark.rasi $HOME/.config/rofi/pywal-color/pywal-theme.rasi
			$pywal_script
			$pywal_refresh
			sleep $INTERVAL
		done
done