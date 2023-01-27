{ config, pkgs, ... }:
{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "http://tplink.server.box".extraConfig = ''
        reverse_proxy http://192.168.1.102
      '';
      "http://tplink.server.tail".extraConfig = ''
        reverse_proxy http://192.168.1.102
      '';
    };
  };
}