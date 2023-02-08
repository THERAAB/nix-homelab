{ config, pkgs, ... }:
let
  network = import ./network.properties.nix;
in
{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "http://tplink.server.box".extraConfig = ''
        reverse_proxy http://${network.tplink.local.ip}
      '';
      "http://tplink.server.tail".extraConfig = ''
        reverse_proxy http://${network.tplink.local.ip}
      '';
      "https://pfsense.server.box".extraConfig = ''
        reverse_proxy https://${network.pfSense.local.ip}
      '';
      "https://pfsense.server.tail".extraConfig = ''
        reverse_proxy https://${network.pfSense.local.ip}
      '';
    };
  };
}