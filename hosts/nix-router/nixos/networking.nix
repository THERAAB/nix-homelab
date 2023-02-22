{ config, lib, pkgs, modulesPath, ... }:
let
  dns-server = "8.8.8.8";
in
{

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "enp2s0" ];
    extraConfig = ''
      subnet 10.13.84.0 netmask 255.255.255.0 {
        option routers 10.13.84.1;
        option domain-name-servers ${dns-server};
        option subnet-mask 255.255.255.0;
        interface enp2s0;
        range 10.13.84.2 10.13.84.254;
      }
    '';
  };

}