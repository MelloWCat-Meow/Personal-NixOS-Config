{ pkgs, inputs, ... }:

let
  stablePkgs = import inputs.nixpkgs-stable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
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
    python3
    zoxide
    gh
    vscodium
    cisco-packet-tracer_9
    stablePkgs.brave
    stablePkgs.brave-origin
    fastfetch
    cowsay
    tenki
    btop
    mpv
    onlyoffice-desktopeditors
    lavat
    nixfmt
    zoom-us
    discord
    uget
    uget-integrator
    wine
    projectlibre
    ani-cli
    cava
    (steam.override {
      extraLibraries =
        pkgs: with pkgs; [
          libxtst
          libxext
          libxrender
          libxi
          libxrandr
          libxxf86vm
          libxcursor
          libxinerama
          gtk3
          glib
          fontconfig
          freetype
          alsa-lib
        ];
    }).run
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
    corefonts
  ];
}
