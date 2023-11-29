#!/bin/bash

STATE=$(hyprctl -j getoption decoration:blur:passes | jq ".int")

case "$1" in
	"--inc")
		result=$(echo "$STATE + 1" | bc)
		hyprctl keyword decoration:blur:passes "$result"
  		notify-send "Blur passes: $result"
		;;
	"--dec")
		result=$(echo "$STATE - 1" | bc)
		hyprctl keyword decoration:blur:passes "$result"
  		notify-send "Blur passes: $result"
		;;
esac