{...}: {
  imports = [
    ./gatus
    ./hardware.nix
    ./adguard-tailscale.nix
    ./caddy.nix
    ./gotify.nix
  ];
}
