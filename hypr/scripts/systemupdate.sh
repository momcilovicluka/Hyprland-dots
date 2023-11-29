#!/usr/bin/env bash

# Check for updates
aur=`yay -Qu | wc -l`

# Calculate total available updates
upd=$(( aur ))

# Show tooltip
if [ $upd -eq 0 ] ; then
    echo "{\"text\":\"$upd\", \"tooltip\":\" Packages are up to date\"}"
else
    echo "{\"text\":\"$upd\", \"tooltip\":\"󱓽 Official $ofc\n󱓾 AUR $aur$fpk_disp\"}"
fi

# Trigger upgrade
if [ "$1" == "up" ] ; then
    kitty --title systemupdate sh -c "${aurhlpr} -Syu $fpk_exup"
fi