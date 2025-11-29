# Arch Linux Environment Configuration

A modular environment setup for Arch Linux with automated installation and configuration scripts. This repository manages system packages, hardware configurations, development tools, and desktop environments across multiple machines.

## Features

- **Modular Design**: Individual scripts for different components (core tools, applications, window managers, etc.)
- **Machine-Specific Configs**: Supports laptop-specific (T480) and desktop-specific configurations
- **Configuration Management**: Dotfiles for i3, Neovim, Tmux, Ghostty, and more
- **Automated Setup**: Shell scripts that handle package installation and configuration deployment
- **AUR Support**: Automated installation of AUR packages via git submodules
- **Hardware Optimization**: T480-specific throttling, power management, and backlight control

## Supported Machines

### ThinkPad T480 Laptop
- Intel 8th Gen Core processors
- Intel UHD Graphics 620
- Dual battery system with optimized power management
- TrackPoint and touchpad
- Backlight control via acpilight
- Throttling mitigation (BD PROCHOT)

### Desktop Workstation
- Wayland/Hyprland compositor (desktop repo)
- High-performance configurations
- Multi-monitor support

## Requirements

- Arch Linux distribution
- Git installed
- sudo privileges

## Project Structure

```
.
├── setup                  # Profile setup script
├── run                    # Main runner script
├── .profile              # Current machine profile (gitignored)
├── profiles/             # Profile definitions
│   ├── laptop-t480       # T480 laptop configuration
│   └── shared            # Minimal shared configuration
├── runs/                  # Installation and setup scripts
│   ├── aur               # AUR package submodules
│   ├── core              # Core system packages
│   ├── t480              # T480-specific hardware configs
│   ├── fonts             # System fonts
│   ├── i3                # i3 window manager
│   ├── nvim              # Neovim configuration
│   ├── dev               # Development tools
│   └── ...               # Additional components
├── files/                # Configuration files and dotfiles
├── aur/                  # AUR package git submodules
└── scripts/              # Utility scripts
```

## Profiles

Profiles define which scripts to run for different machine types. Each profile is a simple text file listing script names.

### Example Profiles

This repo includes example profiles that you can use as references:

- **laptop-t480**: Full T480 laptop setup with hardware optimizations, X11/i3, and all applications
- **shared**: Minimal setup with just core tools, development environment, and terminal config

**Important**: These are just examples. You should create your own profile specific to your machine.

### Creating Your Own Profile

When you get a new machine, create a profile for it:

1. **Examine existing profiles** for examples:
   ```bash
   cat profiles/laptop-t480
   cat profiles/shared
   ```

2. **Create your profile**:
   ```bash
   # Create profiles/my-new-laptop
   cat > profiles/my-new-laptop << 'EOF'
   # My New Laptop Profile
   # Custom setup for my new machine

   # Core system
   aur
   core
   fonts

   # Development
   dev
   nvim
   tmux

   # Add other scripts as needed
   EOF
   ```

3. **Activate your profile**:
   ```bash
   ./setup my-new-laptop
   ```

4. **Run setup**:
   ```bash
   DEV_ENV=$(pwd) ./run
   ```

## Usage

### First Time Setup - Create Your Profile

```bash
cd ~/env

# Look at example profiles for reference
cat profiles/laptop-t480
cat profiles/shared

# Create your own profile for this machine
cat > profiles/my-machine << 'EOF'
# My Machine Profile
aur
core
fonts
dev
nvim
tmux
EOF

# Set your profile
./setup my-machine
```

This creates a `.profile` file that remembers your machine's configuration.

### Run All Scripts for Your Profile

```bash
DEV_ENV=$(pwd) ./run
```

### Dry Run (preview what would execute)

```bash
DEV_ENV=$(pwd) ./run --dry
```

### Run Specific Components (with filtering)

```bash
# Install only fonts (filters scripts by name)
DEV_ENV=$(pwd) ./run fonts

# Setup only T480-specific hardware
DEV_ENV=$(pwd) ./run t480

# Install only core packages
DEV_ENV=$(pwd) ./run core
```

### Temporarily Override Profile

```bash
# Use shared profile just for this run
DEV_ENV=$(pwd) ./run --profile shared

# Use laptop profile from a machine that has shared set
DEV_ENV=$(pwd) ./run --profile laptop-t480
```

## Installation Examples

### Fresh Machine Setup (Generic)

```bash
# Clone the repository
git clone https://github.com/ge3224/env.git ~/env
cd ~/env

# Look at existing profiles for examples
ls -la profiles/
cat profiles/shared

# Create a profile for your new machine
cat > profiles/my-machine << 'EOF'
# My New Machine Profile

# Core essentials
aur
core
fonts

# Development tools
dev
nvim
tmux

# Add machine-specific scripts as needed
EOF

# Activate your profile
./setup my-machine

# Run setup
DEV_ENV=$(pwd) ./run
```

### Using an Existing Example Profile

If an example profile matches your needs (like T480):

```bash
git clone https://github.com/ge3224/env.git ~/env
cd ~/env

# Review the profile first
cat profiles/laptop-t480

# If it fits, use it
./setup laptop-t480
DEV_ENV=$(pwd) ./run
```

### Install Specific Components

```bash
# Just install development environment
DEV_ENV=$(pwd) ./run dev

# Just setup T480 hardware optimizations
DEV_ENV=$(pwd) ./run t480

# Just install fonts
DEV_ENV=$(pwd) ./run fonts
```

## Component Overview

### System Components
- **pacman**: Package manager configuration (multilib, color, updates)
- **core**: Essential utilities (ripgrep, fd, tree, imagemagick, etc.)
- **fonts**: Comprehensive font coverage with Nerd Fonts
- **keyboard**: Keyboard remapping (CapsLock → Esc)
- **aur**: AUR package management via submodules

### Hardware (T480-Specific)
- **t480**: Throttling control, backlight, firmware updates
  - throttled service for CPU throttling mitigation
  - BD PROCHOT disabling via throttlestop
  - acpilight for backlight control
  - udev rules for video group permissions

### Desktop Environment
- **i3**: i3 window manager and i3status
- **xresources**: X11 resources configuration
- **ghostty**: Terminal emulator

### Development
- **dev**: Language toolchains (Rust, Go, Node, Deno, OCaml, Docker)
- **nvim**: Neovim with LSP support
- **tmux**: Terminal multiplexer

### Applications
- **signal**: Signal Desktop
- **tailscale**: VPN
- **pandoc**: Document conversion with LaTeX
- **printing**: CUPS printing system
- **usb**: USB automounting utilities
- **cheat**: CLI cheatsheet manager

## Benefits Over Ansible

- No Python/Ansible dependencies
- Faster execution
- Easier to read and debug
- Standard bash tooling
- Simple, transparent scripts
- Idempotent operations

## Unification Plan

This repository is designed to be unified with the desktop environment configuration. Machine detection will allow conditional execution of:
- Laptop-specific scripts (power management, T480 hardware)
- Desktop-specific scripts (Hyprland, Wayland tools)
- Shared scripts (core, fonts, dev tools, nvim, tmux)

## License

MIT License - See LICENSE file for details

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Submit a pull request
