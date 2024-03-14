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
      podman.enable = true;
      system.enable = true;
      hardware = {
        enable = true;
        hostName = config.networking.hostName;
      };
    };
  };
}
