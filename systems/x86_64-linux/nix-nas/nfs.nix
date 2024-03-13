{properties, ...}: let
  nfs-dir = "/nfs";
  media-dir = "${nfs-dir}/media";
  backups-dir = "${nfs-dir}/backups";
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
  networking.firewall.allowedTCPPorts = [2049 4001 4000 4002 111];
  services.nfs.server = {
    enable = true;
    lockdPort = 4001;
    statdPort = 4000;
    mountdPort = 4002;
    exports = ''
      ${nfs-dir}    ${properties.network.nix-hypervisor.local.ip}(rw,fsid=0,no_subtree_check) ${properties.network.nix-hypervisor.tailscale.ip}(rw,fsid=0,no_subtree_check)
      ${media-dir}  ${properties.network.micro-media.local.ip}(rw,nohide,insecure,no_subtree_check,anonuid=${toString properties.users.nfsnobody.uid}) ${properties.network.micro-download.local.ip}(rw,nohide,insecure,no_subtree_check,anonuid=${toString properties.users.nfsnobody.uid})
      ${backups-dir}  ${properties.network.nix-hypervisor.local.ip}(rw,nohide,insecure,no_subtree_check,anonuid=${toString properties.users.nfsnobody.uid},no_root_squash) ${properties.network.nix-hypervisor.tailscale.ip}(rw,nohide,insecure,no_subtree_check,anonuid=${toString properties.users.nfsnobody.uid},no_root_squash)
    '';
  };
}
