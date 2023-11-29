#!/bin/bash

STATE=$(hyprctl -j getoption decoration:blur:brightness | jq ".float")

case "$1" in
	"--inc")
		result=$(echo "$STATE + 0.1" | bc)
		hyprctl keyword decoration:blur:brightness "$result"
  		notify-send "Background brightness: $result"
		;;
	"--dec")
		result=$(echo "$STATE - 0.1" | bc)
		hyprctl keyword decoration:blur:brightness "$result"
  		notify-send "Background brightness: $result"
		;;
esac