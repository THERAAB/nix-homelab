{...}: let
  network = import ../../../share/network.properties.nix;
in {
  fileSystems = {
    "/media" = {
      device = "${network.nix-nas.tailscale.ip}:/nfs/media";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=1200"];
    };
    "/backups" = {
      device = "${network.nix-nas.tailscale.ip}:/nfs/backups";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=1200"];
    };
  };
}
