# Desktop/display server: GNOME (GDM) sebagai session utama, Hyprland
# tersedia sebagai session terpisah di login screen (dipakai lewat
# Caelestia, lihat modules/home/caelestia.nix).

{ pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-hyprland
    ];
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.xserver.excludePackages = [ pkgs.xterm ];
}
