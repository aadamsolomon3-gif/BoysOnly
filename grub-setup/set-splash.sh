#!/usr/bin/env bash
set -e

echo "=== Plymouth Theme Installer (Automatic Replacement + Splash Fix) ==="

# Detect the directory where the script is running
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Variables
THEME_NAME="mc"                # name of the theme folder you want to apply
THEME_BACKUP_DIR="$SCRIPT_DIR/plymouth-themes"  # relative folder containing your themes
PLYMOUTH_DIR="/usr/share/plymouth/themes"

# Ensure running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run with sudo."
    exit 1
fi

# Remove existing theme if it exists
if [ -d "$PLYMOUTH_DIR/$THEME_NAME" ]; then
    echo "Removing existing theme: $PLYMOUTH_DIR/$THEME_NAME"
    rm -rf "$PLYMOUTH_DIR/$THEME_NAME"
fi

# Copy Plymouth theme from backup to system
echo "Copying theme from $THEME_BACKUP_DIR/$THEME_NAME to $PLYMOUTH_DIR"
cp -r "$THEME_BACKUP_DIR/$THEME_NAME" "$PLYMOUTH_DIR/"

# Set proper permissions
chmod -R 755 "$PLYMOUTH_DIR/$THEME_NAME"
chown -R root:root "$PLYMOUTH_DIR/$THEME_NAME"

# Set the theme as default
echo "Setting Plymouth theme..."
plymouth-set-default-theme -R "$THEME_NAME"

# --- Ensure Plymouth hook is in mkinitcpio.conf ---
MKINITCPIO_CONF="/etc/mkinitcpio.conf"
if ! grep -q "plymouth" "$MKINITCPIO_CONF"; then
    echo "Adding plymouth to HOOKS in $MKINITCPIO_CONF..."
    # Insert plymouth before 'filesystems'
    sudo sed -i 's/\(HOOKS=.*\)filesystems/\1plymouth filesystems/' "$MKINITCPIO_CONF"
fi

# Regenerate initramfs
echo "Regenerating initramfs..."
mkinitcpio -P

# --- Ensure 'splash' is in GRUB_CMDLINE_LINUX_DEFAULT ---
GRUB_CONF="/etc/default/grub"
if grep -q "GRUB_CMDLINE_LINUX_DEFAULT" "$GRUB_CONF"; then
    echo "Ensuring 'splash' is in GRUB_CMDLINE_LINUX_DEFAULT..."
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\([^"]*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 splash"/' "$GRUB_CONF"
else
    echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"' >> "$GRUB_CONF"
fi

# Regenerate GRUB configuration
echo "Regenerating GRUB config..."
grub-mkconfig -o /boot/grub/grub.cfg

echo "Plymouth theme '$THEME_NAME' applied successfully!"
echo "Reboot to see your login screen with splash."
