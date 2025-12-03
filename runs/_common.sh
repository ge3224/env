#!/usr/bin/env bash

is_package_installed() {
    if [ -n "${INSTALLED_PACKAGES:-}" ]; then
        echo "$INSTALLED_PACKAGES" | grep -q "^$1$"
    else
        pacman -Q "$1" >/dev/null 2>&1
    fi
}

has_internet() {
    if [ -n "${HAS_INTERNET:-}" ]; then
        [ "$HAS_INTERNET" = "true" ]
    else
        ping -c 1 -W 2 archlinux.org >/dev/null 2>&1
    fi
}

install_packages() {
    local missing_packages=()

    for package in "$@"; do
        if ! is_package_installed "$package"; then
            missing_packages+=("$package")
        fi
    done

    if [[ ${#missing_packages[@]} -gt 0 ]]; then
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
