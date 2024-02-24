{...}: {
  imports = [
    ../../../share/optional/acme.nix
  ];
  services.caddy.enable = true;
}
