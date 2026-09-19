{ ... }:
{
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
  nix.settings = {
    max-jobs = 1;
    cores = 2;
  };
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
}
