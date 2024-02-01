#!/bin/bash
# checl if wlsunset is running
if [ "$(pidof wlsunset)" ]; then
    pkill -f wlsunset
    notify-send "WLSUNSET" "Sunset disabled" -i ~/.config/dunst/icons/brightness-100.png
else
    wlsunset -l 45.2 -L 19.8 -t 4000 -T 6500 &#-d 900 -S 07:00 -s 19:00
    notify-send "WLSUNSET" "Sunset enabled" -i ~/.config/dunst/icons/brightness-60.png
fi