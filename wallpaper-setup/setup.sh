#!/usr/bin/env bash
set -e

# Paths
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
CONFIG="$HOME/.config/illogical-impulse/config.json"

# Ask which user's wallpaper to set
echo "Choose whose wallpaper to set:"
echo "1) Aadam"
echo "2) Shawaal"
echo "3) Abdudaiyaan"
read -rp "Enter 1, 2, or 3: " choice

case "$choice" in
    1) USER="aadam" ;;
    2) USER="shawaal" ;;
    3) USER="abdudaiyaan" ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

# Find the first .jpg file in that user's wallpapers folder
WALLPAPER="$(find "$SCRIPT_DIR/$USER/wallpapers" -maxdepth 1 -type f -name '*.jpg' | head -n 1)"

if [ -z "$WALLPAPER" ]; then
    echo "No JPG wallpaper found in $USER/wallpapers."
    exit 1
fi

# Update the config.json
sed -i "s|\"wallpaperPath\": \".*\"|\"wallpaperPath\": \"$WALLPAPER\"|" "$CONFIG"

echo "Wallpaper for $USER set to $WALLPAPER."
