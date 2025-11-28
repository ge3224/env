# Ansible to Bash Migration

This document describes the migration from Ansible to bash scripts for managing the ThinkPad T480 Arch Linux configuration.

## What Changed

### Before (Ansible)
- Configuration managed via `main.yml` playbook
- 20 separate task files in `tasks/` directory
- Required Ansible and Python dependencies
- Interactive prompts for username and sudo password
- ~1700+ lines of YAML

### After (Bash)
- Simple `run` script as the entry point
- 19 modular bash scripts in `runs/` directory
- No external dependencies beyond bash and standard tools
- ~1000 lines of bash scripts
- Simpler, more transparent, easier to debug

## New Structure

```
.
├── run                    # Main runner script
├── runs/                  # Individual setup scripts
│   ├── 01-submodules     # Git submodule initialization
│   ├── 02-pacman         # Pacman configuration
│   ├── 03-core           # Core packages
│   ├── 04-keyboard       # Keyboard mapping (CapsLock->Esc)
│   ├── 05-xresources     # X11 resources
│   ├── 06-t480           # T480-specific hardware configs
│   ├── 07-fonts          # Font installation
│   ├── 08-zsh            # Zsh setup
│   ├── 09-ghostty        # Ghostty terminal
│   ├── 10-i3             # i3 window manager
│   ├── 11-tmux           # Tmux configuration
│   ├── 12-signal         # Signal Desktop
│   ├── 13-tailscale      # Tailscale VPN
│   ├── 14-dev            # Development tools
│   ├── 15-nvim           # Neovim configuration
│   ├── 16-usb            # USB utilities
│   ├── 17-cheat          # Cheat CLI cheatsheets
│   ├── 18-pandoc         # Pandoc and LaTeX
│   └── 19-printing       # CUPS printing system
├── dotfiles/             # Configuration files
├── aur/                  # AUR packages as submodules
└── scripts/              # Utility scripts
```

## Usage

### Run All Setup Scripts

```bash
DEV_ENV=$(pwd) ./run
```

### Dry Run (see what would execute)

```bash
DEV_ENV=$(pwd) ./run --dry
```

### Run Specific Scripts (filter by name)

```bash
# Run only T480-specific setup
DEV_ENV=$(pwd) ./run t480

# Run only core packages
DEV_ENV=$(pwd) ./run core

# Run only i3 setup
DEV_ENV=$(pwd) ./run i3
```

## Benefits of Bash Approach

1. **Simpler**: No Ansible dependency, just bash
2. **Faster**: Direct execution, no Python/Ansible overhead
3. **Transparent**: Easy to read and understand what each script does
4. **Modular**: Each script is independent and can be run individually
5. **Debuggable**: Standard bash debugging tools work
6. **Portable**: Works anywhere bash is available
7. **Idempotent**: Scripts check before installing/configuring

## Migration Notes

Each bash script:
- Uses `set -euo pipefail` for safety
- Has a consistent logging format
- Checks if packages are already installed
- Uses `--needed --noconfirm` for pacman
- Creates symlinks safely (removes existing first)
- Returns proper exit codes

## T480-Specific Features

The `06-t480` script configures:
- Throttling control (throttled package and throttlestop service)
- BD PROCHOT mitigation
- Backlight control (acpilight)
- Udev rules for video group permissions
- Firmware update tools (fwupd)

## Next Steps

This bash-based approach can be easily unified with the desktop dotfiles repo by:
1. Adding machine detection logic
2. Conditionally running laptop vs desktop specific scripts
3. Sharing common scripts between both machines
