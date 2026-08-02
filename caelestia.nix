{ inputs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };

  home-manager.users.mellowcat =
    {
      config,
      pkgs,
      lib,
      inputs,
      ...
    }:
    {
      imports = [ inputs.caelestia-shell.homeManagerModules.default ];
      home.stateVersion = "26.05";

      programs.caelestia = {
        enable = true;
        cli.enable = true;
        systemd.enable = false;
      };

      xdg.configFile = {
        "caelestia" = {
          source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/caelestia";
          force = true;
          recursive = true;
        };
        "fish/config.fish".source = lib.mkForce (
          config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/fish/config.fish"
        );
        "fish/functions/fish_greeting.fish".source =
          config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/fish/functions/fish_greeting.fish";
        "starship.toml".source =
          config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/fish/starship.toml";
        "foot/foot.ini".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/foot/foot.ini";
        "fastfetch/config.jsonc".source =
          config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/fastfetch/config.jsonc";
        "hypr/hyprland.lua" = {
          source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/hypr/hyprland.lua";
          force = true;
        };
      };

      programs.fish.enable = true;
      programs.starship.enable = true;
      home.packages = with pkgs; [
        foot
        direnv
        zoxide
        eza
        lazygit
      ];

      home.pointerCursor = {
        enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
        gtk.enable = true;
      };

      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";
        settings = { };
        extraLuaFiles = {
          "duplicate" = "/etc/nixos/dotfiles/hypr/hyprland.lua";
        };
      };
    };
}
