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

    # Autostart caelestia shell saat masuk session Hyprland
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "exec-once" = [ "caelestia shell -d" ];
      };
    };
  };
}