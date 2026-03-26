#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
# Wallpaper Effects using ImageMagick
# Inspiration from ML4W - Stephan Raabe https://gitlab.com/stephan-raabe/dotfiles

# Variables
current_wallpaper="$HOME/.config/rofi/.current_wallpaper"
wallpaper_output="$HOME/.config/rofi/.modified_wallpaper"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
effects_cache_dir="$HOME/.cache/wallpaper-effects"
#focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')


# Directory for swaync
iDIR="$HOME/.config/dunst/images"

# swww transition config
FPS=60
TYPE="wipe"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

# Define ImageMagick effect names
effects=(
    "Black & White"
    "Blurred"
    "Charcoal"
    "Edge Detect"
    "Emboss"
    "Negate"
    "Oil Paint"
    "Posterize"
    "Polaroid"
    "Sepia Tone"
    "Solarize"
    "Sharpen"
    "Vignette"
    "Zoomed"
)

apply_effect() {
    local effect_name="$1"
    local source_file="$2"
    local output_file="$3"
    
    case "$effect_name" in
        "Black & White") magick "$source_file" -colorspace gray -sigmoidal-contrast 10,40% "$output_file" ;;
        "Blurred") magick "$source_file" -blur 0x10 "$output_file" ;;
        "Charcoal") magick "$source_file" -charcoal 0x5 "$output_file" ;;
        "Edge Detect") magick "$source_file" -edge 1 "$output_file" ;;
        "Emboss") magick "$source_file" -emboss 0x5 "$output_file" ;;
        "Negate") magick "$source_file" -negate "$output_file" ;;
        "Oil Paint") magick "$source_file" -paint 4 "$output_file" ;;
        "Posterize") magick "$source_file" -posterize 4 "$output_file" ;;
        "Polaroid") magick "$source_file" -polaroid 0 "$output_file" ;;
        "Sepia Tone") magick "$source_file" -sepia-tone 65% "$output_file" ;;
        "Solarize") magick "$source_file" -solarize 80% "$output_file" ;;
        "Sharpen") magick "$source_file" -sharpen 0x5 "$output_file" ;;
        "Vignette") magick "$source_file" -vignette 0x5 "$output_file" ;;
        "Zoomed") magick "$source_file" -gravity Center -extent 1:1 "$output_file" ;;
        *) return 1 ;;
    esac
}

build_effect_cache() {
    local effect_name="$1"
    local source_file="$2"
    
    mkdir -p "$effects_cache_dir"
    
    local source_sig
    source_sig=$(stat -Lc '%n|%s|%Y' "$source_file")
    
    local cache_key
    cache_key=$(printf '%s|%s' "$source_sig" "$effect_name" | sha256sum | awk '{print $1}')
    
    local cache_file="$effects_cache_dir/${cache_key}.png"
    if [ -f "$cache_file" ]; then
        cp "$cache_file" "$wallpaper_output"
        return 0
    fi
    
    if ! apply_effect "$effect_name" "$source_file" "$cache_file"; then
        return 1
    fi
    
    cp "$cache_file" "$wallpaper_output"
    return 0
}

# Function to apply no effects
no-effects() {
    awww img -o "$focused_monitor" "$current_wallpaper" $SWWW_PARAMS &
    # Wait for swww command to complete
    wait $!
    # Run other commands after swww
    wallust run "$current_wallpaper" -s &
    # Wait to complete
    wait $!
    # Refresh rofi, waybar, wallust palettes
    "${SCRIPTSDIR}/Refresh.sh"
    notify-send -u low -i "$iDIR/bell3.png" "No wallpaper effects"
    # copying wallpaper for rofi menu
    cp "$current_wallpaper" "$wallpaper_output"
}

# Function to run rofi menu
main() {
    local cli_choice="$1"
    # Populate rofi menu options
    options=("No Effects")
    for effect in "${effects[@]}"; do
        options+=("$effect")
    done
    
    # Show rofi menu and handle user choice (or use CLI argument).
    if [ -n "$cli_choice" ]; then
        choice="$cli_choice"
    else
        choice=$(printf "%s\n" "${options[@]}" | LC_COLLATE=C sort | rofi -dmenu -p "Choose effect" -i -config ~/.config/rofi/config-wallpaper-effect.rasi)
    fi
    
    # Process user choice
    if [[ -n "$choice" ]]; then
        if [[ "$choice" == "No Effects" ]]; then
            no-effects
            elif printf '%s\n' "${effects[@]}" | grep -Fxq "$choice"; then
            # Apply selected effect
            notify-send -u normal -i "$iDIR/bell3.png" "Applying $choice effects"
            
            source_wallpaper=$(readlink -f "$current_wallpaper" 2>/dev/null || true)
            if [ -z "$source_wallpaper" ] || [ ! -f "$source_wallpaper" ]; then
                notify-send -u critical -i "$iDIR/bell3.png" "Could not resolve current wallpaper"
                return 1
            fi
            
            if ! build_effect_cache "$choice" "$source_wallpaper"; then
                notify-send -u critical -i "$iDIR/bell3.png" "Failed applying $choice"
                return 1
            fi
            
            # Execute awww command after image conversion
            awww img -o "$focused_monitor" "$wallpaper_output" $SWWW_PARAMS &
            # Wait for swww command to complete
            wait $!
            # Wait for other commands to finish
            wallust run "$wallpaper_output" -s &
            # Wait for other commands to finish
            wait $!
            # Refresh rofi, waybar, wallust palettes
            "${SCRIPTSDIR}/Refresh.sh"
            notify-send -u low -i "$iDIR/bell3.png" "$choice effects applied"
        else
            echo "Effect '$choice' not recognized."
        fi
    fi
}

# Check if rofi is already running and kill it
if pidof rofi > /dev/null; then
    pkill rofi
    exit 0
fi

main "$1"case "$effect_name" in
        "Black & White") magick "$source_file" -colorspace gray -sigmoidal-contrast 10,40% "$output_file" ;;
        "Blurred") magick "$source_file" -blur 0x10 "$output_file" ;;
        "Charcoal") magick "$source_file" -charcoal 0x5 "$output_file" ;;
        "Edge Detect") magick "$source_file" -edge 1 "$output_file" ;;
        "Emboss") magick "$source_file" -emboss 0x5 "$output_file" ;;
        "Negate") magick "$source_file" -negate "$output_file" ;;
        "Oil Paint") magick "$source_file" -paint 4 "$output_file" ;;
        "Posterize") magick "$source_file" -posterize 4 "$output_file" ;;
        "Polaroid") magick "$source_file" -polaroid 0 "$output_file" ;;
        "Sepia Tone") magick "$source_file" -sepia-tone 65% "$output_file" ;;
        "Solarize") magick "$source_file" -solarize 80% "$output_file" ;;
        "Sharpen") magick "$source_file" -sharpen 0x5 "$output_file" ;;
        "Vignette") magick "$source_file" -vignette 0x5 "$output_file" ;;
        "Zoomed") magick "$source_file" -gravity Center -extent 1:1 "$output_file" ;;
        *) return 1 ;;
    esac
}

build_effect_cache() {
    local effect_name="$1"
    local source_file="$2"

    mkdir -p "$effects_cache_dir"

    local source_sig
    source_sig=$(stat -Lc '%n|%s|%Y' "$source_file")

    local cache_key
    cache_key=$(printf '%s|%s' "$source_sig" "$effect_name" | sha256sum | awk '{print $1}')

    local cache_file="$effects_cache_dir/${cache_key}.png"
    if [ -f "$cache_file" ]; then
        cp "$cache_file" "$wallpaper_output"
        return 0
    fi

    if ! apply_effect "$effect_name" "$source_file" "$cache_file"; then
        return 1
    fi

    cp "$cache_file" "$wallpaper_output"
    return 0
}

# Function to apply no effects
no-effects() {
    awww img -o "$focused_monitor" "$current_wallpaper" $SWWW_PARAMS &
    # Wait for swww command to complete
    wait $!
    # Run other commands after swww
    wallust run "$current_wallpaper" -s &
    # Wait to complete
    wait $!
    # Refresh rofi, waybar, wallust palettes
    "${SCRIPTSDIR}/Refresh.sh"
    notify-send -u low -i "$iDIR/bell3.png" "No wallpaper effects"
    # copying wallpaper for rofi menu
    cp "$current_wallpaper" "$wallpaper_output"
}

# Function to run rofi menu
main() {
    local cli_choice="$1"
    # Populate rofi menu options
    options=("No Effects")
    for effect in "${effects[@]}"; do
        options+=("$effect")
    done
    
    # Show rofi menu and handle user choice (or use CLI argument).
    if [ -n "$cli_choice" ]; then
        choice="$cli_choice"
    else
        choice=$(printf "%s\n" "${options[@]}" | LC_COLLATE=C sort | rofi -dmenu -p "Choose effect" -i -config ~/.config/rofi/config-wallpaper-effect.rasi)
    fi
    
    # Process user choice
    if [[ -n "$choice" ]]; then
        if [[ "$choice" == "No Effects" ]]; then
            no-effects
            elif printf '%s\n' "${effects[@]}" | grep -Fxq "$choice"; then
            # Apply selected effect
            notify-send -u normal -i "$iDIR/bell3.png" "Applying $choice effects"

            source_wallpaper=$(readlink -f "$current_wallpaper" 2>/dev/null || true)
            if [ -z "$source_wallpaper" ] || [ ! -f "$source_wallpaper" ]; then
                notify-send -u critical -i "$iDIR/bell3.png" "Could not resolve current wallpaper"
                return 1
            fi

            if ! build_effect_cache "$choice" "$source_wallpaper"; then
                notify-send -u critical -i "$iDIR/bell3.png" "Failed applying $choice"
                return 1
            fi

            # Execute awww command after image conversion
            awww img -o "$focused_monitor" "$wallpaper_output" $SWWW_PARAMS &
            # Wait for swww command to complete
            wait $!
            # Wait for other commands to finish
            wallust run "$wallpaper_output" -s &
            # Wait for other commands to finish
            wait $!
            # Refresh rofi, waybar, wallust palettes
            "${SCRIPTSDIR}/Refresh.sh"
            notify-send -u low -i "$iDIR/bell3.png" "$choice effects applied"
        else
            echo "Effect '$choice' not recognized."
        fi
    fi
}

# Check if rofi is already running and kill it
if pidof rofi > /dev/null; then
    pkill rofi
    exit 0
fi

main "$1"