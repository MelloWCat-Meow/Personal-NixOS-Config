{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    configurationLimit = 2;
  };
  boot.loader.timeout = 30;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  systemd.services.nixos-gc-generations = {
    description = "Prune old system generations to match boot.configurationLimit";
    serviceConfig.Type = "oneshot";
    path = [pkgs.nix];
    script = ''
      nix-env --delete-generations +2 --profile /nix/var/nix/profiles/system
      nix-collect-garbage -d
      /run/current-system/bin/switch-to-configuration boot
    '';
  };

  systemd.timers.nixos-gc-generations = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
