{...}: {
  imports = [
    ./users.nix
    ./hardware.nix
    ./sops.nix
    ./harmonia.nix
    ./syncthing.nix
    ./restic.nix
    ./microvm.nix
  ];
  nix-homelab = {
    core = {
      flakes.enable = true;
      system.enable = true;
    };
    wrappers = {
      olivetin.enable = true;
    };
  };
  systemd.timers.nix-flake-update.timerConfig.OnCalendar = "Sun *-*-* 04:20:00";
  system.autoUpgrade.dates = "Sun *-*-* 04:30:00";
  services.netdata.config.registry.enabled = "yes";
}
