{self, ...}: {
  imports = [
    (self + /share/nixos/server)
    ./hardware.nix
    ./adguard-tailscale.nix
  ];
  nix-homelab = {
    server.enable = true;
    networking.nfs.enable = true;
  };
  services.netdata.config.registry.enabled = "no";
}
