#!/usr/bin/env bash
set -e

# Paths
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
DEST="$HOME/.config/kitty"
SRC_BACKGROUND="$SCRIPT_DIR/backgrounds"
SRC_KITTY_CONF="$SCRIPT_DIR/kitty.conf"

# Create kitty config folder if it doesn't exist
mkdir -p "$DEST"

# Copy/replace backgrounds folder
if [ -d "$SRC_BACKGROUND" ]; then
    rm -rf "$DEST/backgrounds"       # Remove old backgrounds if exists
    cp -r "$SRC_BACKGROUND" "$DEST/"
    echo "Backgrounds folder copied."
fi

# Copy/replace kitty.conf
if [ -f "$SRC_KITTY_CONF" ]; then
    cp "$SRC_KITTY_CONF" "$DEST/kitty.conf"
    echo "kitty.conf replaced."
fi

echo "Kitty configuration updated successfully."
