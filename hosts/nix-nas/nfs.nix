{...}: let
  nfs-dir = "/nfs";
  media-dir = "${nfs-dir}/media";
  backups-dir = "${nfs-dir}/backups";
  network = import ../../share/network.properties.nix;
  users = import ../../share/users.properties.nix;
in {
  systemd.tmpfiles.rules = [
    "d    ${nfs-dir}      755  -  -       -   - "
    "Z    ${media-dir}    775  -  media   -   - "
    "Z    ${backups-dir}  775  -  restic  -   - "
  ];
  fileSystems = {
    "${media-dir}" = {
      device = "/dev/disk/by-label/media";
      fsType = "btrfs";
      options = ["subvol=media" "compress=zstd" "noatime"];
    };
    "${backups-dir}" = {
      device = "/dev/disk/by-label/media";
      fsType = "btrfs";
      options = ["subvol=backups" "compress=zstd" "noatime"];
    };
  };
  networking.firewall.allowedTCPPorts = [2049];
  services.nfs.server = {
    enable = true;
    exports = ''
      ${nfs-dir}    ${network.nix-hypervisor.local.ip}(rw,fsid=0,no_subtree_check) ${network.nix-hypervisor.tailscale.ip}(rw,fsid=0,no_subtree_check)
      ${media-dir}  ${network.micro-media.local.ip}(rw,nohide,insecure,no_subtree_check,anonuid=${toString users.nfsnobody.uid}) ${network.micro-media.tailscale.ip}(rw,nohide,insecure,no_subtree_check,anonuid=${toString users.nfsnobody.uid})
      ${backups-dir}  ${network.nix-hypervisor.local.ip}(rw,nohide,insecure,no_subtree_check,anonuid=${toString users.nfsnobody.uid}) ${network.nix-hypervisor.tailscale.ip}(rw,nohide,insecure,no_subtree_check,anonuid=${toString users.nfsnobody.uid})
    '';
  };
}