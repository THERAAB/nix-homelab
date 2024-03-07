{...}: let
  network = import ../../share/network.properties.nix;
in {
  fileSystems = {
    "/media" = {
      device = "${network.nix-nas.local.ip}:/nfs/media";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=1200"];
    };
  };
}
