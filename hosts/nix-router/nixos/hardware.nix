{ config, lib, pkgs, ... }:
let
  dns-server = "8.8.8.8";
  network = import ../../../share/network.properties.nix;
in
{
  networking = {
    hostName = "nix-router";
    nftables.enable = true;
    nameservers = [ "${dns-server}" ];
    trustedInterfaces = [ "enp2s0" "enp3s0" "enp4s0" ];

    interfaces = {
      # WAN
      enp1s0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = "${network.nix-router.local.ip}";
          prefixLength = 24;
        }];
      };
      # LAN 1
      enp2s0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = "10.10.11.1";
          prefixLength = 24;
        }];
      };
      # LAN 2
      enp3s0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = "10.10.12.1";
          prefixLength = 24;
        }];
      };
      # LAN 3
      enp4s0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = "10.10.13.1";
          prefixLength = 24;
        }];
      };
    };
  };
}