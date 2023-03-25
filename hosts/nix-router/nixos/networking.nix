{ config, lib, pkgs, ... }:
let
  network = import ../../../share/network.properties.nix;
in
{
  networking = {
    hostName = "nix-router";
    nftables.enable = true;
#    nameservers = [ "${network.localhost}" ];
    nameservers = [ "1.1.1.1" ];
#    firewall.trustedInterfaces = network.lan-interfaces;
    firewall.trustedInterfaces = ["eno1"];
    nat.enable = true;
#    nat.externalInterface = network.wan-interface;
    nat.externalInterface = "enp1s0";
#    nat.internalInterfaces = network.lan-interfaces;
    nat.internalInterfaces = ["eno1"];

    interfaces = {
      # WAN
      enp1s0 = {
        useDHCP = true;
        #ipv4.addresses = [{
        #  address = "${network.nix-router.local.ip}";
        #  prefixLength = network.prefixLength;
        #}];
      };
      # LAN 1
#      enp2s0 = {
#        useDHCP = true;
#        ipv4.addresses = [{
#          address = network.lan1-address;
#          prefixLength = network.prefixLength;
#        }];
#      };
      # LAN 2 (Desktop)
      eno1 = {
#        useDHCP = true;
        useDHCP = true;
        ipv4.addresses = [{
#          address = network.lan2-address;
          address = "10.10.12.1";
          prefixLength = network.prefixLength;
        }];
      };
      # LAN 3
#      enp4s0 = {
#        useDHCP = true;
#        ipv4.addresses = [{
#          address = network.lan3-address;
#          prefixLength = network.prefixLength;
#        }];
#      };
    };
  };
}