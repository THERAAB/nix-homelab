{ config, lib, pkgs, ... }:
let
  dns-server = "8.8.8.8";
  network = import ../../../share/network.properties.nix;
  lan-interfaces = [ "enp2s0" "enp3s0" "enp4s0" ];
  wan-interface = "enp1s0";
  prefixLength = 24;
in
{
  networking = {
    hostName = "nix-router";
    nftables.enable = true;
    nameservers = [ "${dns-server}" ];
    firewall.trustedInterfaces = lan-interfaces;
    nat.enable = true;
    nat.externalInterface = wan-interface;
    nat.internalInterfaces = lan-interfaces;

    interfaces = {
      # WAN
      enp1s0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = "${network.nix-router.local.ip}";
          prefixLength = prefixLength;
        }];
      };
      # LAN 1
      enp2s0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = "10.10.11.1";
          prefixLength = prefixLength;
        }];
      };
      # LAN 2
      enp3s0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = "10.10.12.1";
          prefixLength = prefixLength;
        }];
      };
      # LAN 3
      enp4s0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = "10.10.13.1";
          prefixLength = prefixLength;
        }];
      };
    };
  };

  services.dnsmasq = {
    settings = {
      server = [ dns-server ];
      interface = [ lan-interfaces ];
      domain-needed = true;
      dhcp-range = [ "10.10.11.100,10.10.11.254,24h" "10.10.12.100,10.10.12.254,24h" "10.10.13.100,10.10.13.254,24h" ];
      dhcp-host = [
        "${network.nix-server.mac},${network.nix-server.local.ip}"
        "${network.desktop.mac},${network.desktop.local.ip}" 
      ];
    };
  };
}