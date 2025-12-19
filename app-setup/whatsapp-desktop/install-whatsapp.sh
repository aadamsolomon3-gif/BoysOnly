#!/usr/bin/env bash
set -e

# Install prerequisites if not already installed
sudo pacman -S --needed --noconfirm git base-devel

# Check if yay is already installed
if ! command -v yay &> /dev/null; then
    echo "Installing yay (AUR helper)..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
else
    echo "yay is already installed, skipping..."
fi

# Check if WhatsApp AUR package is installed
if pacman -Qs whatsapp-linux-desktop-bin &> /dev/null; then
    echo "WhatsApp is already installed, skipping..."
else
    echo "Installing WhatsApp..."
    yay -S --noconfirm whatsapp-linux-desktop-bin
    echo "Installation complete! You can now run WhatsApp."
fi
