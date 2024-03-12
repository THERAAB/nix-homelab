{...}: let
  network = import ../../assets/properties/network.properties.nix;
  media = import ../../assets/properties/media.properties.nix;
in {
  users = {
    users.root.extraGroups = ["media"];
    groups.media.gid = media.group.id;
  };
  fileSystems = {
    "/media" = {
      device = "${network.nix-nas.local.ip}:/nfs/media";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=1200"];
    };
  };
}
