#!/usr/bin/env bash
set -e

echo "=== Running All Boot & Login Setup Scripts in Order ==="

# Detect script folder
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Define your scripts in the order you want them to run
SCRIPTS=(
    "$SCRIPT_DIR/set-sddm.sh"
    "$SCRIPT_DIR/set-splash.sh"
    "$SCRIPT_DIR/install-grub.sh"
    "$SCRIPT_DIR/set-theme.sh"
)

# Run each script
for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        echo
        echo "=== Running: $(basename "$script") ==="
        sudo bash "$script" || echo "Warning: $(basename "$script") failed but continuing..."
    else
        echo "Warning: Script not found: $script"
    fi
done

echo
echo "=== All scripts executed! ==="
echo "Reboot your system to see full effect (GRUB → Plymouth → SDDM)."
