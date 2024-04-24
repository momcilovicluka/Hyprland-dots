#!/bin/bash

pywal_script=$HOME/.config/hypr/scripts/PywalSwww.sh
pywal_refresh=$HOME/.config/hypr/scripts/Refresh.sh

# WALLPAPERS PATH
DIR=$HOME/Pictures/wallpapers

# Transition config (type swww img --help for more settings
FPS=60
TYPE="any"
DURATION=1

# wofi window config (in %)
WIDTH=10
HEIGHT=30

SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

PICS=($(ls ${DIR} | grep -e ".jpg$" -e ".jpeg$" -e ".png$" -e ".gif$"))
#PICS=($(find ${DIR} -type f -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif"))
# remove the path from the array
#for i in ${!PICS[@]}; do
#    PICS[$i]=$(echo ${PICS[$i]} | rev | cut -d/ -f1 | rev)
#done

RANDOM_PIC=${PICS[$RANDOM % ${#PICS[@]}]}
RANDOM_PIC_NAME="${#PICS[@]}. random"

# WOFI STYLES
CONFIG="$HOME/.config/wofi/WofiBig/config"
STYLE="$HOME/.config/wofi/style.css"
COLORS="$HOME/.config/wofi/colors"

# to check if swaybg is running
if [[ $(pidof swaybg) ]]; then
	pkill swaybg
fi

## Wofi Command
#wofi_command="wofi --show dmenu \
#			--prompt choose...
#			--conf $CONFIG --style $STYLE --color $COLORS \
#			--width=$WIDTH% --height=$HEIGHT% \
#			--cache-file=/dev/null \
#			--hide-scroll --no-actions \
#			--matching=fuzzy"
rofi_command="rofi -show -dmenu -config ~/.config/rofi/config-wallpaper.rasi"

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

swww query || swww-daemon &

main() {
	#choice=$(menu | ${wofi_command})
	choice=$(menu | ${rofi_command})

	# no choice case
	if [[ -z $choice ]]; then return; fi

	# random choice case
	if [ "$choice" = "$RANDOM_PIC_NAME" ]; then
		swww img ${DIR}/${RANDOM_PIC} $SWWW_PARAMS
		$pywal_script
		$pywal_refresh
		return
	fi

	pic_index=$(echo $choice | cut -d. -f1)
	swww img ${DIR}/${PICS[$pic_index]} $SWWW_PARAMS
	# for cava-pywal (note, need to manually restart cava once wallpaper changes)
	ln -sf "$HOME/.cache/wal/cava-colors" "$HOME/.config/cava/config" || true
	$pywal_script
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
