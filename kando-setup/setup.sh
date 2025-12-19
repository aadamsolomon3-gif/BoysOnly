#!/usr/bin/env bash
set -e

# --- 0) Function to check if a package is installed ---
is_installed() {
    local pkg="$1"
    if pacman -Qs "$pkg" &> /dev/null || yay -Qs "$pkg" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# --- 1) Install kando-bin silently if not installed ---
if is_installed "kando-bin"; then
    echo "kando-bin is already installed, skipping installation..."
else
    echo "Installing kando-bin..."
    yes | yay -S --noconfirm kando-bin
fi

# --- 2) Copy local 'kando' folder to ~/.config ---
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
LOCAL_KANDO="$SCRIPT_DIR/kando"
DEST_KANDO="$HOME/.config/kando"

if [[ -d "$LOCAL_KANDO" ]]; then
    echo "Copying local kando folder to ~/.config..."
    rm -rf "$DEST_KANDO" 2>/dev/null
    cp -a "$LOCAL_KANDO" "$DEST_KANDO"
    echo "Local kando folder copied to ~/.config/kando."
else
    echo "No 'kando' folder found in script directory. Skipping copy."
fi

# --- 3) Add exec-once to Hyprland ---
EXEC_FILE="$HOME/.config/hypr/hyprland/execs.conf"
mkdir -p "$(dirname "$EXEC_FILE")"
LINE="exec-once = kando"
if ! grep -Fxq "$LINE" "$EXEC_FILE" 2>/dev/null; then
    echo -e "# Kando Menu\n$LINE" >> "$EXEC_FILE"
    echo "Kando exec added to execs.conf."
else
    echo "Kando exec already exists in execs.conf."
fi

# --- 4) Add keybind for Kando ---
KEYBIND_FILE="$HOME/.config/hypr/hyprland/keybinds.conf"
mkdir -p "$(dirname "$KEYBIND_FILE")"

# Replace :example-menu with the actual menu shortcut you want
MENU_ID=":example-menu"
KEYBIND="bind = CTRL, Space, global, $MENU_ID # Kando Menu"

if ! grep -Fxq "$KEYBIND" "$KEYBIND_FILE" 2>/dev/null; then
    echo "$KEYBIND" >> "$KEYBIND_FILE"
    echo "Keybind added to keybinds.conf."
else
    echo "Keybind already exists in keybinds.conf."
fi

# --- 5) Reload Hyprland ---
if command -v hyprctl &> /dev/null; then
    echo "Reloading Hyprland..."
    hyprctl reload
else
    echo "hyprctl not found. Please reload Hyprland manually."
fi

echo "Kando installation and setup complete!"
