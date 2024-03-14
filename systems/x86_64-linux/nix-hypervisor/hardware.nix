{properties, ...}: {
  # Force kernel to use iommu (GPU passthrough)
  boot.kernelParams = ["intel_iommu=on" "iommu=pt"];
  networking.hostName = "nix-hypervisor";
  services.irqbalance.enable = true;
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
