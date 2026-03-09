{properties, ...}: {
  networking.firewall.allowedTCPPorts = [properties.ports.http properties.ports.ssl];
  services.caddy = {
    enable = true;
  };
}
