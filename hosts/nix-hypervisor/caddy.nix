{...}: {
  imports = [
    ../../share/optional/acme.nix
  ];
  services.caddy.enable = true;
  networking.firewall.allowedTCPPorts = [80 443];
}
