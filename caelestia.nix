{ inputs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };

  home-manager.users.mellowcat = { config, pkgs, inputs, ... }: {
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
        "exec-once" = [ "caelestia shell -d" ];

        bind = [
          "$mod, Return, exec, $terminal"
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

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      };
    };
  };
}