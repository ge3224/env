#!/usr/bin/env bash
set -euo pipefail

echo "========================================="
echo "Reflector: Speed-Optimized Mirror Update"
echo "========================================="
echo ""
echo "This script performs comprehensive speed testing to find the fastest mirrors."
echo "This may take several minutes as it downloads from multiple mirrors."
echo ""

# Check if reflector is installed
if ! command -v reflector &> /dev/null; then
    echo "ERROR: reflector is not installed"
    echo "Install it with: sudo pacman -S reflector"
    exit 1
fi

# Check for internet connectivity
echo "Checking internet connectivity..."
if ! ping -c 1 -W 2 archlinux.org >/dev/null 2>&1; then
    echo "ERROR: No internet connectivity detected"
    echo "Please check your connection and try again"
    exit 1
fi
echo "Internet connection confirmed"
echo ""

# Backup current mirrorlist
timestamp=$(date +%Y%m%d_%H%M%S)
backup_file="/etc/pacman.d/mirrorlist.backup_$timestamp"
echo "Backing up current mirrorlist to: $backup_file"
sudo cp /etc/pacman.d/mirrorlist "$backup_file"
echo ""

# Show current top mirrors
echo "Current top 5 mirrors:"
grep "^Server" /etc/pacman.d/mirrorlist | head -5 || echo "  (none configured)"
echo ""

# Perform speed-optimized mirror selection
echo "Starting comprehensive mirror speed testing..."
echo "Testing parameters:"
echo "  - Latest 20 recently synced mirrors"
echo "  - HTTPS protocol only"
echo "  - Sorted by download rate (speed)"
echo ""
echo "This will take a few minutes - please wait..."
echo ""

if sudo reflector \
    --latest 20 \
    --protocol https \
    --sort rate \
    --save /etc/pacman.d/mirrorlist; then

    echo ""
    echo "========================================="
    echo "Mirror update completed successfully!"
    echo "========================================="
    echo ""
    echo "/etc/pacman.d/mirrorlist has been updated with the fastest mirrors"
    echo ""
    echo "New top 5 fastest mirrors:"
    grep "^Server" /etc/pacman.d/mirrorlist | head -5
    echo ""
    echo "Original mirrorlist backed up to: $backup_file"
    echo ""
    echo "Updating package databases with new mirrors..."
    if sudo pacman -Sy; then
        echo "Package databases synchronized successfully"
    else
        echo "WARNING: Failed to synchronize package databases"
        echo "You may need to run 'sudo pacman -Sy' manually"
    fi
    echo ""
    echo "To revert to previous mirrors, run:"
    echo "  sudo cp $backup_file /etc/pacman.d/mirrorlist"
    echo "  sudo pacman -Sy"
else
    echo ""
    echo "ERROR: Mirror update failed"
    echo "Restoring previous mirrorlist from backup..."
    sudo cp "$backup_file" /etc/pacman.d/mirrorlist
    echo "Previous mirrorlist restored"
    exit 1
fi
