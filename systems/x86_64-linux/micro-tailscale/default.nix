{config, ...}: {
  imports = [
    ./hardware.nix
    ./adguard-tailscale.nix
    ./caddy.nix
  ];
  nix-homelab = {
    core.enable = true;
    networking.acme.enable = true;
    microvm = {
      enable = true;
      hostName = config.networking.hostName;
    };
  };
}
