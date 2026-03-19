{self, ...}: {
  imports = [
    (self + /share/nixos/server)
    ./hardware.nix
    ./adguard-tailscale.nix
  ];
  nix-homelab = {
    server.enable = true;
    networking.nfs.enable = true;
    wrappers.beszel-agent.enable = true;
  };
  services.beszel.agent.environment.EXTRA_FILESYSTEMS = "sda1";
  services.netdata.config.registry.enabled = "no";
}
