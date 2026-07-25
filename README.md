# ❄️ mellowcat's NixOS Config

This is my personal NixOS setup with GNOME and Hyprland (Caelestia Dotfiles). I'm just a beginner student still learning Nix, so if you spot something that could be improved, feel free to let me know. Feel free to adapt whatever's useful to you too, and don't hesitate to ask if anything's confusing :)

## Overview

- **OS**: NixOS (using flakes)
- **Desktop Environment**: GNOME (main session), plus Hyprland through [Caelestia Shell](https://github.com/caelestia-dots/shell) as a separate session
- **Shell**: fish + starship
- **Terminal**: foot
- **Home Manager**: used to manage Caelestia/Hyprland dotfiles

## Structure

```
.
├── flake.nix              # Flake entry point, holds the inputs (nixpkgs, home-manager, caelestia-shell)
├── flake.lock
├── configuration.nix       # Main system configuration
├── caelestia.nix           # Home Manager + Hyprland/Caelestia module
├── hardware-configuration.nix  # specific to my machine, so it's gitignored, generate your own
└── dotfiles/               # fish, starship, foot, fastfetch configs (symlinked)
```

## Notes

- Dual boots with Windows on the same NVMe drive.
- GNOME is kept around for gaming, Hyprland is the daily driver.
- `hardware-configuration.nix` is intentionally not tracked, just run `sudo nixos-generate-config` to make your own before building.

## If you want to adapt this

1. Clone this repo.
2. Generate your own `hardware-configuration.nix`.
3. Change `networking.hostName` and the username in `configuration.nix` / `caelestia.nix` to match yours.
4. Adjust the monitor settings and keybinds in `caelestia.nix` to your liking.
5. `sudo nixos-rebuild switch --flake .#nixos`

I'm still learning a lot about Nix myself, so if you have corrections or ideas, feel free to open an issue!