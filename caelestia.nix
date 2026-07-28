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
        configType = "hyprlang";
        settings = {
          "$mod" = "SUPER";
          "$terminal" = "foot";
          "$browser" = "brave";
          "$files" = "nautilus";
          "$ide" = "codium";
          "exec-once" = [ "caelestia shell -d" ];

          # Force Electron/Chromium/Qt apps (Brave, VSCodium, Discord) to render
          # natively on Wayland instead of falling back to blurry XWayland.
          env = [
            "NIXOS_OZONE_WL,1"
            "QT_QPA_PLATFORM,wayland"
          ];

          monitor = [
            ",preferred,auto,1.2"
          ];

          bindel = [
            ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ",XF86MonBrightnessUp, exec, caelestia shell brightness set +5%"
            ",XF86MonBrightnessDown, exec, caelestia shell brightness set 5%-"
          ];

          bind = [
            "$mod, Return, exec, $terminal"
            "$mod, W, exec, $browser"
            "$mod, E, exec, $files"
            "$mod, C, exec, $ide"
            "$mod, Q, killactive"
            "$mod, M, exit"
            "$mod, V, togglefloating"
            "$mod, F, fullscreen"
            "$mod, D, global, caelestia:launcher"
            "$mod, L, global, caelestia:lock"

            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
          ];

          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];

          decoration = {
            rounding = 10;
            rounding_power = 2;

            blur = {
              enabled = true;
              size = 5;
              passes = 2;
            };

            shadow = {
              enabled = true;
              range = 15;
              render_power = 3;
            };
          };
        };
      };
    };
}
