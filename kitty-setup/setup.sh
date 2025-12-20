#!/usr/bin/env bash
set -e

# Paths
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
DEST="$HOME/.config/kitty"

# Ask user whose configuration they want
echo "Choose a configuration to apply:"
echo "1) Aadam"
echo "2) Shawaal"
echo "3) Abdudaiyaan"
read -rp "Enter 1, 2, or 3: " choice

case "$choice" in
    1) USER_FOLDER="aadam" ;;
    2) USER_FOLDER="shawaal" ;;
    3) USER_FOLDER="abdudaiyaan" ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

SRC_BACKGROUND="$SCRIPT_DIR/$USER_FOLDER/backgrounds"
SRC_KITTY_CONF="$SCRIPT_DIR/$USER_FOLDER/kitty.conf"

# Create kitty config folder if it doesn't exist
mkdir -p "$DEST"

# Copy/replace backgrounds folder
if [ -d "$SRC_BACKGROUND" ]; then
    rm -rf "$DEST/backgrounds"       # Remove old backgrounds if exists
    cp -r "$SRC_BACKGROUND" "$DEST/"
    echo "Backgrounds folder copied from $USER_FOLDER."
fi

# Copy/replace kitty.conf
if [ -f "$SRC_KITTY_CONF" ]; then
    cp "$SRC_KITTY_CONF" "$DEST/kitty.conf"
    echo "kitty.conf replaced from $USER_FOLDER."
fi

echo "Kitty configuration for $USER_FOLDER applied successfully."
