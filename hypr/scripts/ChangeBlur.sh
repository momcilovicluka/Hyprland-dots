#!/bin/bash

STATE=$(hyprctl -j getoption decoration:blur:passes | jq ".int")

if [ "${STATE}" == "4" ]; then
  hyprctl keyword decoration:blur:size 2
  hyprctl keyword decoration:blur:passes 2
  notify-send "Low blur"
elif [ "${STATE}" == "2" ]; then
  hyprctl keyword decoration:blur:size 3
  hyprctl keyword decoration:blur:passes 3
  notify-send "Middle blur"
else
  hyprctl keyword decoration:blur:size 3
  hyprctl keyword decoration:blur:passes 4
  notify-send "High blur"
fi
