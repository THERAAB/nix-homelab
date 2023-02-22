{ config, lib, pkgs, ... }:
let
  network = import ../../../share/network.properties.nix;
  lan-interfaces = [ "enp2s0" "enp3s0" "enp4s0" ];
  lan1-address = "10.10.11.1";
  lan2-address = "10.10.12.1";
  lan3-address = "10.10.13.1";
  wan-interface = "enp1s0";
  prefixLength = 24;
  localhost = "127.0.0.1";
in
{
  networking = {
    hostName = "nix-router";
    nftables.enable = true;
    nameservers = [ "${localhost}" ];
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
          address = lan1-address;
          prefixLength = prefixLength;
        }];
      };
      # LAN 2
      enp3s0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = lan2-address;
          prefixLength = prefixLength;
        }];
      };
      # LAN 3
      enp4s0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = lan3-address;
          prefixLength = prefixLength;
        }];
      };
    };
  };

  services.dnsmasq = {
    settings = {
      server = [ localhost ];
      interface = [ lan-interfaces ];
      domain-needed = true;
      dhcp-range = [ "10.10.11.100,10.10.11.254,24h" "10.10.12.100,10.10.12.254,24h" "10.10.13.100,10.10.13.254,24h" ];
      dhcp-host = [
        "${network.nix-server.mac},${network.nix-server.local.ip}"
        "${network.desktop.mac},${network.desktop.local.ip}"
      ];
    };
  };

  services.avahi = {
    enable = true;
    reflector = true;
    interfaces = [ "enp2s0" "enp3s0" "enp4s0" ];
  };

  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" "0.0.0.0" ];
        access-control = [
          "127.0.0.0/8 allow"
          "${lan1-address} allow"
          "${lan2-address} allow"
          "${lan3-address} allow"
        ];
      };
    };
  };
}