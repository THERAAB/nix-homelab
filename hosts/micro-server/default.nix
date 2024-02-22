{...}: {
  imports = [
    ./adguard
    ./system.nix
    ./gatus
    ./caddy.nix
    ./gotify.nix
    ./unifi.nix
  ];
}
