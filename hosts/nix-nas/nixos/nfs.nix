{...}: let
  nfs-dir = "/nfs";
  media-dir = "${nfs-dir}/media";
  network = import ../../../share/network.properties.nix;
in {
  systemd.tmpfiles.rules = [
    "d    /nix/persist${nfs-dir}  -    -        -        -   - "
    "Z    ${nfs-dir}              777  nobody   nogroup  -   - "
  ];
  fileSystems."${nfs-dir}" = {
    device = "/nix/persist${nfs-dir}";
    options = ["bind"];
  };
  fileSystems."${media-dir}" = {
    device = "/dev/disk/by-label/media";
    fsType = "btrfs";
    options = ["subvol=media" "compress=zstd" "noatime"];
  };
  networking.firewall.allowedTCPPorts = [2049];
  services.nfs.server = {
    enable = true;
    exports = ''
      ${nfs-dir}    ${network.nix-server.local.ip}(rw,fsid=0,no_subtree_check) ${network.nix-server.tailscale.ip}(rw,fsid=0,no_subtree_check)
      ${media-dir}  ${network.nix-server.local.ip}(rw,nohide,insecure,no_subtree_check) ${network.nix-server.tailscale.ip}(rw,nohide,insecure,no_subtree_check)
    '';
  };
}
