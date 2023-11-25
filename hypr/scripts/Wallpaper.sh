#!/bin/bash

DIR=$HOME/Pictures/wallpapers/Dynamic-Wallpapers/Dark/
PICS=($(find ${DIR} -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))
RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

pywal_script=$HOME/.config/hypr/scripts/PywalSwww.sh
pywal_refresh=$HOME/.config/hypr/scripts/Refresh.sh

change_swaybg(){
  #pkill swww
  #pkill swaybg
  #swaybg -m fill -i ${RANDOMPICS}

  pkill swaybg
  swww query || swww init
  swww img ${RANDOMPICS} --transition-fps 60 --transition-type any --transition-duration 3
  wal -i ${RANDOMPICS} -n
  pywalfox update
  pywal-discord -p /home/luka/.config/VencordDesktop/VencordDesktop/themes/
  cp $HOME/.cache/wal/colors-rofi-dark.rasi $HOME/.config/rofi/pywal-color/pywal-theme.rasi
  $pywal_script
  $pywal_refresh
}

change_swww(){
  pkill swaybg
  swww query || swww init
  swww img ${RANDOMPICS} --transition-fps 60 --transition-type any --transition-duration 3
  wal -i ${RANDOMPICS} -n
  pywalfox update
  pywal-discord -p /home/luka/.config/VencordDesktop/VencordDesktop/themes/
  cp $HOME/.cache/wal/colors-rofi-dark.rasi $HOME/.config/rofi/pywal-color/pywal-theme.rasi
  $pywal_script
  $pywal_refresh
}

change_current(){
  if pidof swaybg >/dev/null; then
    change_swaybg
  else
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
  "s")
		switch
		;;
	*)
		change_current
		;;
esac