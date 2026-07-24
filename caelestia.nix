{ inputs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };

  home-manager.users.mellowcat =
    {
      config,
      pkgs,
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

      # Symlink shell.json ke folder dotfiles di repo /etc/nixos kamu sendiri
      # (ganti path ini sesuai lokasi folder dotfiles kamu yang sebenarnya)
      xdg.configFile."caelestia" = {
        source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/caelestia";
        force = true;
        recursive = true;
      };

      home.packages = with pkgs; [ foot ];

      # Autostart caelestia shell saat masuk session Hyprland
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
            "$mod, T, exec, $terminal"
            "$mod, B, exec, $browser"
            "$mod, E, exec, $files"
            "$mod, C, exec, $ide"
            "$mod, Q, killactive"
            "$mod, M, exit"
            "$mod, V, togglefloating"
            "$mod, F, fullscreen"
            "$mod, D, global, caelestia:launcher"

            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
          ];

          decoration = {
            rounding = 10; # makin besar makin bulat, coba 8-15 buat awal
            rounding_power = 2; # opsional, atur kurva rounding (2 = default/circular)

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

          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];
        };
      };
    };
}
