#!/usr/bin/env bash

# Common helper functions for run scripts
# Source this file in run scripts: source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

# Check if a package is installed
is_package_installed() {
    pacman -Q "$1" >/dev/null 2>&1
}

# Check for internet connectivity
has_internet() {
    ping -c 1 -W 2 archlinux.org >/dev/null 2>&1
}

# Install packages only if they're not already installed
# Usage: install_packages package1 package2 package3...
install_packages() {
    local missing_packages=()

    for package in "$@"; do
        if ! is_package_installed "$package"; then
            missing_packages+=("$package")
        fi
    done

    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        # Check for internet connectivity before attempting installation
        if ! has_internet; then
            echo "WARNING: Missing packages but no internet connectivity detected"
            echo "Missing packages: ${missing_packages[*]}"
            echo "Please install manually when online: sudo pacman -S ${missing_packages[*]}"
            return 1
        fi

        echo "Installing missing packages: ${missing_packages[*]}"
        sudo pacman -S --needed --noconfirm "${missing_packages[@]}"
    else
        echo "All packages are already installed, skipping installation"
    fi
}

# Install packages with logging (for scripts that use log function)
# Usage: install_packages_with_log log_prefix package1 package2 package3...
install_packages_with_log() {
    local log_prefix="$1"
    shift
    local missing_packages=()

    for package in "$@"; do
        if ! is_package_installed "$package"; then
            missing_packages+=("$package")
        else
            echo "[$log_prefix] Package $package is already installed, skipping"
        fi
    done

    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        # Check for internet connectivity before attempting installation
        if ! has_internet; then
            echo "[$log_prefix] WARNING: Missing packages but no internet connectivity detected"
            echo "[$log_prefix] Missing packages: ${missing_packages[*]}"
            echo "[$log_prefix] Please install manually when online: sudo pacman -S ${missing_packages[*]}"
            return 1
        fi

        echo "[$log_prefix] Installing missing packages: ${missing_packages[*]}"
        sudo pacman -S --needed --noconfirm "${missing_packages[@]}"
    else
        echo "[$log_prefix] All packages are already installed"
    fi
}
