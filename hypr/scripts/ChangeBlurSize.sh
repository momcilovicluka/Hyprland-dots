#!/bin/bash

STATE=$(hyprctl -j getoption decoration:blur:size | jq ".int")

case "$1" in
	"--inc")
		result=$(echo "$STATE + 1" | bc)
		hyprctl keyword decoration:blur:size "$result"
  		notify-send "Blur size: $result"
		;;
	"--dec")
		result=$(echo "$STATE - 1" | bc)
		hyprctl keyword decoration:blur:size "$result"
  		notify-send "Blur size: $result"
		;;
esac