#!/usr/bin/env bash

# Installs Flatpak if it’s not already installed
sudo pacman -S flatpak

# Add the Flathub repository (if not already added)
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# This will download and install Kando as a Flatpak
flatpak install flathub menu.kando.Kando

# Add to hyperlands exec file
LINE="# Kando Menu
exec-once = kando"
FILE="$HOME/.config/hypr/hyprland/execs.conf"

# Check if the exec line already exists
if ! grep -Fxq "exec-once = kando" "$FILE"; then
    echo -e "$LINE" >> "$FILE"
    echo "Kando exec added."
else
    echo "Kando exec already exists."
fi

# Add keybind to open the example menu
KEYBIND="bind = CTRL, Space, global, :example-menu"
FILE="$HOME/.config/hypr/hyprland/keybinds.conf"

# Check if the keybind already exists
if ! grep -Fxq "$KEYBIND" "$FILE"; then
    echo "$KEYBIND" >> "$FILE"
    echo "Keybind added."
else
    echo "Keybind already exists."
fi

# Reload Hyprland to apply changes
hyprctl reload
