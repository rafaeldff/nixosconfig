# Project Overview

This repository contains personal NixOS configuration files. It's designed to be a modular and reusable way to configure different NixOS machines, with a clear separation between base configurations, hardware-specific settings, and user-level packages. The configuration is managed through a combination of NixOS modules and `home-manager`.

## Key Files

*   `configuration-*.nix`: These are the main entry points for different machine configurations (e.g., `configuration-desktop.nix`, `configuration-mac.nix`). They import other modules to build the final system configuration.
*   `custom-*.nix`: These files contain host-specific or user-specific settings, allowing for easy customization without modifying the core configuration files.
*   `home-manager.nix`: This file configures `home-manager` to manage user-level packages and dotfiles for different users.
*   `home/`: This directory contains the `home-manager` configurations for different users or profiles (e.g., `fw.nix`, `nu.nix`).
*   `shell.nix`: Configures the shell environment, including prompt, aliases, and environment variables.
*   `*.nix` (various): The repository is broken down into many smaller `.nix` files, each responsible for a specific part of the configuration (e.g., `applications-packages.nix`, `security.nix`, `xmonad-settings.nix`).

## Building and Running

To use this configuration on a new NixOS machine, you need to:

1.  Create two new files for your machine, following the naming convention `configuration-WORKSTATION.nix` and `custom-WORKSTATION.nix`. You can use the existing `*-mac.nix` files as a template.
2.  Run the `install.sh` script as root, passing your workstation name as an argument:

    ```bash
    sudo ./install.sh WORKSTATION
    ```

    This script will likely copy your configuration files to `/etc/nixos/` and then run `nixos-rebuild switch` to apply the configuration.

## Development Conventions

*   **Modularity:** The configuration is highly modular, with different aspects of the system configured in separate files. This makes it easier to manage and reuse parts of the configuration across different machines.
*   **Customization:** Host-specific customizations are handled in `custom-*.nix` files, keeping the base configuration clean.
*   **Home Manager:** User-level configurations are managed with `home-manager`, allowing for declarative management of dotfiles and user packages.
