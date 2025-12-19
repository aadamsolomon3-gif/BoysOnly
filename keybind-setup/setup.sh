#!/usr/bin/env bash
set -e

# Get directory where the script is located
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

DEST_DIR="$HOME/.config/hypr/hyprland"
DEST_FILE="$DEST_DIR/keybinds.conf"

echo "Please choose one of the following options:
[1] Aadam
[2] Abdudaiyaan
[3] Shawaal"
read -rp "Your choice (1-3): " choice

case "$choice" in
    1)
        SRC_FILE="$SCRIPT_DIR/aadam/keybinds.conf"
        ;;
    2)
        SRC_FILE="$SCRIPT_DIR/abdudaiyaan/keybinds.conf"
        ;;
    3)
        SRC_FILE="$SCRIPT_DIR/shawaal/keybinds.conf"
        ;;
    *)
        echo "Invalid choice. Please run the script again and choose 1, 2, or 3."
        exit 1
        ;;
esac

# Ensure destination directory exists
mkdir -p "$DEST_DIR"

# Ensure source file exists
if [[ ! -f "$SRC_FILE" ]]; then
    echo "Error: $SRC_FILE does not exist"
    exit 1
fi

# Copy and replace without confirmation
cp -f "$SRC_FILE" "$DEST_FILE"

echo "keybinds.conf has been updated successfully."
