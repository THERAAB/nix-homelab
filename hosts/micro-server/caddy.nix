{...}: let
  network = import ../../share/network.properties.nix;
in {
  imports = [
    ../../share/optional/acme.nix
  ];
  networking.firewall.allowedTCPPorts = [80 443];
  services.caddy = {
    enable = true;
    virtualHosts = {
    };
  };
}
