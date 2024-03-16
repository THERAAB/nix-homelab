{self, ...}: {
  imports = [
    (self + /share/nixos/server)
    ./hardware.nix
  ];
  nix-homelab = {
    server.enable = true;
    networking.nfs.enable = true;
  };
  services.netdata.config.registry.enabled = "no";
}
