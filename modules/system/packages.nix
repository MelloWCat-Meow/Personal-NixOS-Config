{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    efibootmgr
    neovim
    wget
    openssl
    nvd
    unzip
    curl
    git
    gh
    vscodium
    brave
    fastfetch
    btop
    mpv
    onlyoffice-desktopeditors
    lavat
    nixfmt
    zoom-us
    discord
    uget
    uget-integrator
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-maps
    gnome-weather
    gnome-contacts
    gnome-music
    gnome-characters
    gnome-connections
    gnome-user-docs
    gnome-logs
    gnome-font-viewer
    gnome-disk-utility
    gnome-calendar
    gnome-remote-desktop
    simple-scan
    showtime
    evince
    papers
    epiphany
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
