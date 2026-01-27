# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
# Rebuild and switch to main system (default specialization)
ns                    # alias for: nh os switch --specialisation 00-main-system

# Update flake inputs and commit lock file
nu                    # alias for: (cd ~/nixos-dots && nix flake update --commit-lock-file)

# Edit configuration in Emacs
ne                    # alias for: emacsclient -c ~/nixos-dots/configuration.nix

# Direct rebuild commands (if not using nh aliases)
sudo nixos-rebuild switch --flake .#mrfluffyPC
sudo nixos-rebuild switch --flake .#mrfluffyLaptop
```

## Architecture

### Multi-Host / Multi-User System

This is a NixOS flake configuration targeting two machines (`mrfluffyPC`, `mrfluffyLaptop`) with three users (`mrfluffy`, `work`, `game`). The `systemName` variable (`"pc"` or `"laptop"`) is passed through `specialArgs` to enable hardware-conditional configuration.

### Specializations

Two boot specializations exist in `configuration.nix`:
- **`00-main-system`**: Default desktop environment with Hyprland, full dev tooling
- **`01-steam`**: Gaming mode with Gamescope, Steam Big Picture, auto-login to `game` user

### Directory Structure

```
flake.nix              # Flake inputs and nixosConfigurations
configuration.nix      # Entry point: users, home-manager, specializations
hardware-configuration.nix
system/                # NixOS modules (boot, hardware, services, packages)
  ├── boot.nix         # Bootloader, kernel config (laptop/pc conditional)
  ├── hardware.nix     # GPU drivers (Intel for laptop, AMD for PC)
  ├── nixOSPkgs.nix    # System packages (~2300 lines)
  ├── services.nix     # System services (greetd, pipewire, etc.)
  └── specialisation/  # Boot mode configs
home/                  # Home Manager user configs
  ├── mrfluffy.nix     # Main user (imports dots/, stylix, services)
  ├── work.nix         # Work user
  ├── game.nix         # Gaming user
  ├── homePkgs.nix     # User packages
  └── stylix.nix       # Unified theming (base16, fonts, cursors)
dots/                  # Application dotfiles as Nix modules
  ├── hyprland.nix     # Primary window manager
  ├── waybar.nix       # Status bar
  ├── foot.nix         # Terminal
  ├── zsh.nix          # Shell config with aliases
  └── doom/            # Doom Emacs config (raw files)
assets/Wallpapers/     # Wallpaper images
```

### Window Manager Selection

Set in `flake.nix` via `window_manager` variable (options: `"hyprland"`, `"niri"`, `"all"`). Currently set to `"hyprland"`. This variable is passed to modules for conditional WM configuration.

### Theming

Stylix + nix-colors provide unified theming across all applications:
- Color scheme: `hardcore` (base00: `#141414`)
- Configured in `home/stylix.nix`

### Conditional Hardware Config

Use the `systemName` variable (`"laptop"` or `"pc"`) for hardware-specific code:
```nix
let
  isLaptop = systemName == "laptop";
  isPc = systemName == "pc";
in
# ... use lib.mkIf for conditional values
```
