# ❄️ mellowcat's NixOS Config

Here is my personal NixOS setup with GNOME and Hyprland (Caelestia Dotfiles), feel free to adapt and ask :)

## Overview

- **OS**: NixOS (flakes-based)
- **Desktop Environments**: GNOME (default session) + Hyprland via [Caelestia Shell](https://github.com/caelestia-dots/shell) (separate login session)
- **Shell**: fish + starship
- **Terminal**: foot
- **Home Manager**: used for Caelestia/Hyprland dotfiles management

## Structure

```
.
├── flake.nix              # Flake entry point, inputs (nixpkgs, home-manager, caelestia-shell)
├── flake.lock
├── configuration.nix       # Main system configuration
├── caelestia.nix           # Home Manager + Hyprland/Caelestia module
├── hardware-configuration.nix  # ⚠️ machine-specific, gitignored — generate your own
└── dotfiles/               # fish, starship, foot, fastfetch configs (symlinked)
```

## Notes

- Dual-boots with Windows on the same NVMe drive.
- GNOME is kept as a fallback/gaming session; Hyprland is the daily driver.
- `hardware-configuration.nix` is intentionally not tracked — run `sudo nixos-generate-config` to create your own before building.

## Adapting this for your own setup

1. Clone the repo.
2. Generate your own `hardware-configuration.nix`.
3. Update `networking.hostName` and the username in `configuration.nix` / `caelestia.nix` to match your system.
4. Adjust monitor settings and keybinds in `caelestia.nix` to your liking.
5. `sudo nixos-rebuild switch --flake .#nixos`

Questions or suggestions are welcome — feel free to open an issue!
