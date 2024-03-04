{...}: let
  port = 8238;
  app-name = "gotify";
in {
  networking.firewall.allowedTCPPorts = [port];
  services.${app-name} = {
    enable = true;
    port = port;
  };
}
