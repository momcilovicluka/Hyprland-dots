#!/bin/sh
############################################################################################################
##   ______  __      __  _______   ________  _______    ______   __    __   ______   __    __  ________   ##
##  /      \|  \    /  \|       \ |        \|       \  /      \ |  \  |  \ /      \ |  \  /  \|        \  ##
## |  $$$$$$\\$$\  /  $$| $$$$$$$\| $$$$$$$$| $$$$$$$\|  $$$$$$\| $$\ | $$|  $$$$$$\| $$ /  $$| $$$$$$$$  ##
## | $$   \$$ \$$\/  $$ | $$__/ $$| $$__    | $$__| $$| $$___\$$| $$$\| $$| $$__| $$| $$/  $$ | $$__      ##
## | $$        \$$  $$  | $$    $$| $$  \   | $$    $$ \$$    \ | $$$$\ $$| $$    $$| $$  $$  | $$  \     ##
## | $$   __    \$$$$   | $$$$$$$\| $$$$$   | $$$$$$$\ _\$$$$$$\| $$\$$ $$| $$$$$$$$| $$$$$\  | $$$$$     ##
## | $$__/  \   | $$    | $$__/ $$| $$_____ | $$  | $$|  \__| $$| $$ \$$$$| $$  | $$| $$ \$$\ | $$_____   ##
##  \$$    $$   | $$    | $$    $$| $$     \| $$  | $$ \$$    $$| $$  \$$$| $$  | $$| $$  \$$\| $$     \  ##
##   \$$$$$$     \$$     \$$$$$$$  \$$$$$$$$ \$$   \$$  \$$$$$$  \$$   \$$ \$$   \$$ \$$   \$$ \$$$$$$$$  ##
## Screenshot Utility                                                                                     ##
## Created by Cybersnake                                                                                  ##
############################################################################################################

# Commands
rofi_command="rofi -l 5"
screenshot="$HOME/.config/hypr/scripts/ScreenShot.sh"

# Buttons
screen="󰍹 Capture screen"
area="󰩬 Capture area"
window=" Capture active window"
infive="󱑀 Take in 5s"
inten="󱑇 Take in 10s"

# Countdown Function
countdown() {
  local seconds=$1

  # Check if notify-send is available (Mako might not be installed on all systems)
  if ! command -v notify-send &> /dev/null; then
    echo "Error: 'notify-send' command not found. Mako might not be installed."
    return 1
  fi

  for sec in $(seq $seconds -1 1); do
    # Create notification content with urgency set to normal (2)
    notify-send "Taking shot in:" "$sec seconds remaining" -u normal
    sleep 1
  done

  # Sleep for 0.1 seconds after the countdown finishes
  sleep 0.1
}

# take shots
shotnow() {
    $screenshot --now
}
shot5() {
    $screenshot --in5
}

shot10() {
    $screenshot --in10
}

shotwin() {
    $screenshot --win
}

shotarea() {
   $screenshot --area
}

# Variable passed to rofi
options="$screen\n$area\n$window\n$infive\n$inten"

chosen="$(echo -e "$options" | $rofi_command -p 'Take A Shot' -dmenu -selected-row 0)"
sleep 1
case $chosen in
    $screen)
        shotnow
        ;;
    $area)
        shotarea
        ;;
    $window)
        shotwin
        ;;
    $infive)
        shot5
        ;;
    $inten)
        shot10
        ;;
esac
