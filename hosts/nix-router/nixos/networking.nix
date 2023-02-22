{ config, lib, pkgs, ... }:
let
  network = import ../../../share/network.properties.nix;
in
{
  networking = {
    hostName = "nix-router";
    nftables.enable = true;
    nameservers = [ "${network.localhost}" ];
    firewall.trustedInterfaces = network.lan-interfaces;
    nat.enable = true;
    nat.externalInterface = network.wan-interface;
    nat.internalInterfaces = network.lan-interfaces;

    interfaces = {
      # WAN
      enp1s0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = "${network.nix-router.local.ip}";
          prefixLength = network.prefixLength;
        }];
      };
      # LAN 1
      enp2s0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = network.lan1-address;
          prefixLength = network.prefixLength;
        }];
      };
      # LAN 2
      enp3s0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = network.lan2-address;
          prefixLength = network.prefixLength;
        }];
      };
      # LAN 3
      enp4s0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = network.lan3-address;
          prefixLength = network.prefixLength;
        }];
      };
    };
  };
}