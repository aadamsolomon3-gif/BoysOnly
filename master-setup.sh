#!/usr/bin/env bash
set -e

echo "==============================="
echo " Fully Automatic Master Installer "
echo "==============================="

# List of install scripts (update with your actual paths)
install_scripts=(
    "wallpaper-setup/setup.sh"
    "ai-setup/setup.sh"
    "app-setup/setup.sh"
    "keybind-setup/setup.sh"
    "kando-setup/setup.sh"
    "kitty-setup/setup.sh"
    "grub-setup/setup.sh"
)

# Function to check if an app/package is installed
is_installed() {
    local pkg="$1"
    if pacman -Qs "$pkg" &> /dev/null; then
        return 0
    elif yay -Qs "$pkg" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Loop through each install script
for script in "${install_scripts[@]}"; do
    if [[ -f "$script" ]]; then
        echo "==============================="
        echo " Running $script..."

        # Run the script from its own directory
        (
            cd "$(dirname "$script")"
            bash "$(basename "$script")" || echo "Warning: $script exited with an error, continuing..."
        )

        echo "Finished $script"
    else
        echo "Warning: $script not found, skipping..."
    fi
done

echo "==============================="
echo "All selected installations complete!"
