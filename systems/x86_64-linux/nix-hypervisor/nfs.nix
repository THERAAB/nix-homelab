{properties, ...}: {
  fileSystems = {
    "/backups" = {
      device = "${properties.network.nix-nas.local.ip}:/nfs/backups";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=1200"];
    };
  };
}
