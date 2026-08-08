# Bootloader (GRUB dual-boot dengan Windows, EFI shared dengan Windows ESP)
# dan pilihan kernel. Dipisah biar configuration.nix per-host tidak perlu
# tahu detail bootloader.

{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    configurationLimit = 5;
  };
  boot.loader.timeout = 30;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
