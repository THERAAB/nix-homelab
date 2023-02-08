{ config, pkgs, ... }:
let
  network = import ./network.properties.nix;
in
{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "http://tplink.${network.domain.local}".extraConfig = ''
        reverse_proxy http://${network.tplink.local.ip}
      '';
      "http://tplink.${network.domain.tail}".extraConfig = ''
        reverse_proxy http://${network.tplink.local.ip}
      '';
    };
  };
}