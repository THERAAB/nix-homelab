{properties, ...}: {
  users = {
    users.root.extraGroups = ["media"];
    groups.media.gid = properties.media.group.id;
  };
  fileSystems = {
    "/media" = {
      device = "${properties.network.nix-nas.local.ip}:/nfs/media";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=1200"];
    };
  };
}
