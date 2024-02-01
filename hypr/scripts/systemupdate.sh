#!/usr/bin/env bash

# Check for updates
# yay -Syy
# pacman -Syy

aur=`yay -Qua | wc -l`
pac=`pacman -Qu | wc -l`

# Calculate total available updates
upd=$(( aur + pac ))

# Show tooltip
if [ $upd -eq 0 ] ; then
    echo "{\"text\":\"$upd\", \"tooltip\":\" Packages are up to date\"}"
else
    echo "{\"text\":\"$upd\", \"tooltip\":\"󱓽 Pacman $pac\n󱓾 AUR $aur$fpk_disp\"}"
fi

# Trigger upgrade
if [ "$1" == "up" ] ; then
    #kitty --title systemupdatepacman sh -c "pacman -Syu"
    kitty --title systemupdateyay sh -c "yay -Syu"
fi
