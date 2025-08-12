# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a modular NixOS configuration system designed to support multiple workstations/hardware configurations. The architecture separates concerns into distinct modules:

- **Configuration Files**: `configuration-{WORKSTATION}.nix` files are the main entry points that import all necessary modules
- **Custom Files**: `custom-{WORKSTATION}.nix` files contain host-specific settings (hostnames, users, hardware-specific configurations)
- **Package Modules**: Organized by category (`base-packages.nix`, `dev-packages.nix`, `utils-packages.nix`, etc.)
- **Service Modules**: Hardware and system services (`platform.nix`, `desktop.nix`, `xmonad-settings.nix`, etc.)
- **Home Manager**: User-level configurations stored in the `home/` directory

## Installation and Setup

### Installing a Configuration
```bash
# Install configuration for a specific workstation (as root)
./install.sh WORKSTATION
```

This script:
1. Copies all `.nix` files (except configuration files) to `/etc/nixos/`
2. Copies the `home/` directory to `/etc/nixos/home/`
3. Copies `configuration-{WORKSTATION}.nix` as `/etc/nixos/configuration.nix`

### Setting Up Home Directory
```bash
# Setup user home directory with dotfiles and symlinks
./setuphome.sh
```

### Updating Configuration
```bash
# Update configuration from system files (commits changes)
./update.sh
```

## Supported Workstations

Current workstation configurations:
- `desktop` - Desktop hardware configuration
- `mac` - MacBook configuration with EFI boot
- `fw` - Framework laptop configuration
- `nu-dell` - Dell laptop (work/Nubank configuration)

## Key Configuration Patterns

### Adding a New Workstation
1. Create `configuration-{NAME}.nix` - copy from existing configuration and modify imports
2. Create `custom-{NAME}.nix` - define hostname, users, and hardware-specific settings
3. Optionally create hardware-specific modules if needed

### Package Management
Packages are organized by purpose:
- `base-packages.nix` - Essential system packages (git, vim, wget)
- `applications-packages.nix` - GUI applications
- `dev-packages.nix` - Development tools and languages
- `utils-packages.nix` - System utilities
- `docker-packages.nix` - Docker and containerization tools

### Home Manager Integration
User-level configurations mirror system-level organization in the `home/` directory. The system imports Home Manager configurations through `home-manager.nix`.

### Window Manager Setup
XMonad is the primary window manager, configured through:
- `xmonad-settings.nix` - X server and XMonad service configuration
- `xmonad-environment-packages.nix` - XMonad-related packages
- `home/xmonad-settings.nix` - User-level XMonad configuration

Sway (Wayland) is also supported with similar modular configuration files.