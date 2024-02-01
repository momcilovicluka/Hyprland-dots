#!/bin/bash

# Directory for icons
iDIR="$HOME/.config/dunst/icons"

# Note: You can add more options below with the following format:
# ["TITLE"]="link"

# Define menu options as an associative array
declare -A menu_options=(
	["80s Jpop 👘🎶"]="https://www.youtube.com/watch?v=WCCovrKvAtU"
	["96.3 Easy Rock 🎸🎶"]="https://radio-stations-philippines.com/easy-rock"
	["Anileap 📺🎶"]="https://www.youtube.com/watch?v=4FBW3mkdKOs"
	["Best Anime Openings 📺🎶"]="https://www.youtube.com/watch?v=doTOBNfjK2k"
	["Chillhop 🛋️🎶"]="http://stream.zeno.fm/fyn8eh3h5f8uv"
	["Full Anime Openings 📺🎶"]="https://www.youtube.com/playlist?list=PLfnHjm1ty2oBB1Ywrvee9t94eFcaUmZVY"
	["Ghibli Music 🎹🎶"]="https://youtube.com/playlist?list=PLNi74S754EXbrzw-IzVhpeAaMISNrzfUy&si=rqnXCZU5xoFhxfOl"
	["Gym Music 💪🎶"]="https://www.youtube.com/watch?v=TUAXew0hPx8"
	["Korean Drama OST 🇰🇷🎶"]="https://youtube.com/playlist?list=PLUge_o9AIFp4HuA-A3e3ZqENh63LuRRlQ"
	["Lofi Girl ☕️🎶"]="https://www.youtube.com/watch?v=jfKfPfyJRdk"
	["Lofi Radio ☕️🎶"]="https://play.streamafrica.net/lofiradio"
	["Naxi Radio 📡🎶"]="https://naxi128.streaming.rs:9152/listen.pls"
	["Play Radio ▶️📻"]="https://www.playradio.rs/index.php"
	["Radio S2 📻🎶"]="https://6069699a9e3f3.streamlock.net/asmedia/index/chunklist_w1831063876.m3u8"
	["Relaxing Music 💆🎶"]="https://youtube.com/playlist?list=PLMIbmfP_9vb8BCxRoraJpoo4q1yMFg4CE"
	["SmoothChill 🛋️🎶"]="https://media-ssl.musicradio.com/SmoothChill"
	["TDI Radio ⛽📻"]="https://streaming.tdiradio.com/tdiradionovisad.mp3"
	["Top Youtube Music 2023 ▶️🎶"]="https://youtube.com/playlist?list=PLDIoUOhQQPlXr63I_vwF9GD8sAKh77dWU&si=y7qNeEVFNgA-XxKy"
	["Youtube Remix ▶️🎶"]="https://youtube.com/playlist?list=PLeqTkIUlrZXlSNn3tcXAa-zbo95j0iN-0"
)

# Function for displaying notifications
notification() {
	dunstify -h string:x-canonical-private-synchronous:sys-notify -u normal -i "$iDIR/music.png" "Playing now: $@"
}

# Main function
main() {
	choice=$(printf "%s\n" "${!menu_options[@]}" | rofi -dmenu -config ~/.config/rofi/config-rofi-Beats.rasi -i -p "")

	if [ -z "$choice" ]; then
		exit 1
	fi

	link="${menu_options[$choice]}"

	notification "$choice"

	# Check if the link is a playlist
	if [[ $link == *playlist* ]]; then
		mpv --shuffle --vid=no "$link"
	else
		mpv --vid=no "$link"
	fi
}

# Check if an online music process is running and send a notification, otherwise run the main function
pkill -f http && dunstify -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/music.png" "Online Music stopped" || main
