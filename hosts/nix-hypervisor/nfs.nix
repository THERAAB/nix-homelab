{...}: let
  network = import ../../share/network.properties.nix;
in {
  fileSystems = {
    "/backups" = {
      device = "${network.nix-nas.tailscale.ip}:/nfs/backups";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=1200"];
    };
  };
}
