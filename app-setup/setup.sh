#!/usr/bin/env bash
set -e

echo "==============================="
echo " Master App Installer Launcher "
echo "==============================="

# List your install scripts
declare -A apps=(
    [1]="WhatsApp - whatsapp-desktop/install-whatsapp.sh"
    [2]="VS Code - vs-code/install-vs.sh"
    [3]="Spotify - spotify/install-spotify.sh"
    [4]="Steam - steam/install-steam.sh"
    [5]="Discord - discord/install-discord.sh"
)

# Show options
echo "Select apps to install (comma-separated, e.g., 1,3,5):"
for i in "${!apps[@]}"; do
    echo "[$i] ${apps[$i]}"
done

read -rp "Your choice: " choices

# Convert input to array
IFS=',' read -ra selected <<< "$choices"

# Run the selected install scripts
for i in "${selected[@]}"; do
    app_script="${apps[$i]#*- }"  # Get script filename
    if [[ -f "$app_script" ]]; then
        echo "==============================="
        echo " Running ${apps[$i]}..."
        bash "$app_script"
        echo "Finished ${apps[$i]}"
    else
        echo "Warning: $app_script not found!"
    fi
done

echo "All selected installations complete!"
