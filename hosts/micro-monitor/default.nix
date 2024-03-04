{...}: {
  imports = [
    ./gatus
    ./hardware.nix
    ./adguard-tailscale.nix
    ./gotify.nix
    ./caddy.nix
  ];
}
