#!/bin/bash

cache_dirs=("$HOME/.cache/awww" "$HOME/.cache/swww")
current_link="$HOME/.config/rofi/.current_wallpaper"
wallpaper_path=""

# Prefer the wallpaper already set by wallpaper-changing scripts.
wallpaper_path=$(readlink -f "$current_link" 2>/dev/null || true)

if [ -n "$wallpaper_path" ] && [ -f "$wallpaper_path" ]; then
    wallust run "$wallpaper_path" #-s
    exit 0
fi

# Cache files may be binary and may contain metadata prefix before absolute path.
for cache_dir in "${cache_dirs[@]}"; do
    [ -d "$cache_dir" ] || continue

    while IFS= read -r cache_file; do
        [ -f "$cache_file" ] || continue

        wallpaper_path=$(strings "$cache_file" | grep -E '^/' | head -n1)
        if [ -n "$wallpaper_path" ] && [ -f "$wallpaper_path" ]; then
            break 2
        fi
    done < <(find "$cache_dir" -maxdepth 1 -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | cut -d' ' -f2-)
done


# execute pywal
#wal -i $wallpaper_path --backend colorz --saturate 0.8
#wallpaper_path without anything before first slash
if [ -z "$wallpaper_path" ] || [ ! -f "$wallpaper_path" ]; then
    # Fallback: use existing rofi link target if available.
    wallpaper_path=$(readlink -f "$current_link" 2>/dev/null || true)
fi

if [ -n "$wallpaper_path" ] && [ -f "$wallpaper_path" ]; then
    ln -sfn "$wallpaper_path" "$current_link"
fi

if [ -z "$wallpaper_path" ] || [ ! -f "$wallpaper_path" ]; then
    echo "No valid wallpaper path found in ~/.cache/awww or ~/.cache/swww" >&2
    exit 1
fi

wallust run "$wallpaper_path" #-s

# execute pywal skipping tty and terminal
#wal -i $wallpaper_path -s -t

# more info regarding Pywal https://github.com/dylanaraps/pywal/wiki/Getting-Started