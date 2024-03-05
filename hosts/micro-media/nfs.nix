{...}: let
  network = import ../../share/network.properties.nix;
in {
  fileSystems = {
    "/media" = {
      device = "${network.nix-nas.tailscale.ip}:/nfs/media"; # TODO: move to local
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=1200"];
    };
  };
}
