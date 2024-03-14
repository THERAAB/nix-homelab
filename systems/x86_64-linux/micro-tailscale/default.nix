{...}: {
  imports = [
    ./hardware.nix
    ./adguard-tailscale.nix
    ./caddy.nix
  ];
  nix-homelab = {
    microvm.enable = true;
    networking.acme.enable = true;
  };
}
