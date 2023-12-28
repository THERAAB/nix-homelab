{...}: let
  nfs-dir = "/nfs";
  network = import ../../../share/network.properties.nix;
in {
  systemd.tmpfiles.rules = [
    "d    ${nfs-dir}        -    -        -        -   - "
    "d    ${nfs-dir}/media  -    -        -        -   - "
    "Z    ${nfs-dir}        777  nobody   nogroup  -   - "
  ];
  #fileSystems."${nfs-dir}/media" = {
  #  device = "/media";
  #  options = [ "bind" ];
  #};
  networking.firewall.allowedTCPPorts = [2049];
  services.nfs.server = {
    enable = true;
    exports = ''
      /${nfs-dir}         ${network.nix-server.local.ip}(rw,fsid=0,no_subtree_check) ${network.nix-server.tailscale.ip}(rw,fsid=0,no_subtree_check)
      /${nfs-dir}/media  ${network.nix-server.local.ip}(rw,nohide,insecure,no_subtree_check) ${network.nix-server.tailscale.ip}(rw,nohide,insecure,no_subtree_check)
    '';
  };
}
