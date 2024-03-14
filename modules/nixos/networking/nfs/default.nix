{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.networking.nfs;
  nfs-dir = "/nfs";
  media-dir = "${nfs-dir}/media";
  backups-dir = "${nfs-dir}/backups";
in {
  options.nix-homelab.networking.nfs = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup network fileshare permissions");
  };
  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d    ${nfs-dir}      755  -  -       -   - "
      "Z    ${media-dir}    775  -  media   -   - "
      "Z    ${backups-dir}  775  -  restic  -   - "
    ];
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
  };
}
