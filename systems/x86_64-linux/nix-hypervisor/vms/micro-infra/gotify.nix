{properties, ...}: let
  port = properties.ports.gotify;
  app-name = "gotify";
in {
  networking.firewall.allowedTCPPorts = [port];
  services.${app-name} = {
    enable = true;
    port = port;
  };
}
