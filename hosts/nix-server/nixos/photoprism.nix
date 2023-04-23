{ config, pkgs, ... }:
let
  port = 2342;
  app-name = "photoprism";
  network = import ../../../share/network.properties.nix;
in
{
  services.${app-name} = {
    enable = true;
    originalsPath = "/photos";
    address = "192.168.3.2";
    settings = {
      PHOTOPRISM_ADMIN_PASSWORD = "insecure";
    };
  };
  services.caddy.virtualHosts = {
    "http://${app-name}.${network.domain.local}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://${app-name}.${network.domain.tail}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  networking.firewall.allowedTCPPorts = [ port ];
}
