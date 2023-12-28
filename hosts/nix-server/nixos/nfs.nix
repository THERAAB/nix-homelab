{...}: let
  network = import ../../../share/network.properties.nix;
in {
  #systemd.tmpfiles.rules = [
  #  "Z /nfs  - raab  users  -   - "
  #];
  fileSystems."/nfs" = {
    device = "${network.nix-nas.tailscale.ip}:/nfs/media";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=1200"];
  };
}
