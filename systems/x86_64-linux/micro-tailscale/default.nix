{...}: {
  imports = [
    ./hardware.nix
    ./adguard-tailscale.nix
    ./caddy.nix
  ];
  nix-homelab.networking.acme.enable = true;
}
