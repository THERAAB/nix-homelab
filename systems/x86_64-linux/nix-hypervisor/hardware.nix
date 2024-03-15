{
  config,
  properties,
  ...
}: {
  # Force kernel to use iommu (GPU passthrough)
  boot.kernelParams = ["intel_iommu=on" "iommu=pt"];
  networking.hostName = "nix-hypervisor";
  services.irqbalance.enable = true;
  systemd.timers.nix-flake-update.timerConfig.OnCalendar = "Sun *-*-* 04:20:00";
  system.autoUpgrade.dates = "Sun *-*-* 04:30:00";
  security.sudo.extraConfig = ''
    olivetin  ALL=(root)  NOPASSWD:/var/lib/olivetin/scripts/commands.sh
    raab      ALL=(root)  NOPASSWD:/run/current-system/sw/bin/flock -w 60 /dev/shm/nixinate-${config.networking.hostName} nixos-rebuild switch --flake /nix/store/[a-zA-Z0-9]*-source\#${config.networking.hostName}
  '';
  fileSystems = {
    "/backups" = {
      device = "${properties.network.nix-nas.local.ip}:/nfs/backups";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=1200"];
    };
    "/sync" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = ["subvol=sync" "compress=zstd" "noatime"];
    };
    "/sync/share/flatnotes" = {
      device = "/var/lib/microvms/micro-server/storage/var/lib/flatnotes";
      options = ["bind"];
    };
  };
}
