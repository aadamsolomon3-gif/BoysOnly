#!/usr/bin/env bash
set -e

echo "=== SDDM Theme Installer ==="

# Detect the script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Variables
THEME_NAME="minesddm"                         # folder name of your theme
THEME_BACKUP_DIR="$SCRIPT_DIR/sddm-themes"   # relative folder with theme
SDDM_DIR="/usr/share/sddm/themes"
SDDM_CONF="/etc/sddm.conf"

# Ensure running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run with sudo."
    exit 1
fi

# Copy theme to SDDM themes directory
if [ -d "$SDDM_DIR/$THEME_NAME" ]; then
    echo "Removing existing theme $SDDM_DIR/$THEME_NAME"
    rm -rf "$SDDM_DIR/$THEME_NAME"
fi
echo "Copying theme from $THEME_BACKUP_DIR/$THEME_NAME to $SDDM_DIR"
cp -r "$THEME_BACKUP_DIR/$THEME_NAME" "$SDDM_DIR/"
chmod -R 755 "$SDDM_DIR/$THEME_NAME"
chown -R root:root "$SDDM_DIR/$THEME_NAME"

# Ensure /etc/sddm.conf exists
if [ ! -f "$SDDM_CONF" ]; then
    echo "Creating $SDDM_CONF"
    echo -e "[Theme]\nCurrent=$THEME_NAME" > "$SDDM_CONF"
else
    # Update Current theme in existing config
    if grep -q "^Current=" "$SDDM_CONF"; then
        sed -i "s/^Current=.*/Current=$THEME_NAME/" "$SDDM_CONF"
    else
        # Add [Theme] section if missing
        if ! grep -q "^\[Theme\]" "$SDDM_CONF"; then
            echo -e "\n[Theme]" >> "$SDDM_CONF"
        fi
        echo "Current=$THEME_NAME" >> "$SDDM_CONF"
    fi
fi

# Restart SDDM to apply the theme (optional)
echo "Restarting SDDM to apply the new theme..."
systemctl restart sddm.service

echo "SDDM theme '$THEME_NAME' applied successfully!"
echo "Your login screen should now show the selected theme."
