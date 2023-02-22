{ config, lib, pkgs, modulesPath, ... }:
let
  dns-server = "8.8.8.8";
in
{
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
  };
  networking = {
    hostName = "nix-router";
    nameservers = [ "${dns-server}" ];
    firewall.enable = false;

    interfaces = {
      enp1s0 = {
        useDHCP = true;
      };
      enp2s0 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "10.13.84.1";
          prefixLength = 24;
        }];
      };
      enp3s0 = {
        useDHCP = false;
      };
      enp4s0 = {
        useDHCP = false;
      };
    };

    nftables = {
      enable = true;
      ruleset = ''
        table ip filter {
          chain input {
            type filter hook input priority 0; policy drop;

            iifname { "enp2s0" } accept comment "Allow local network to access the router"
            iifname "enp1s0" ct state { established, related } accept comment "Allow established traffic"
            iifname "enp1s0" icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow select ICMP"
            iifname "enp1s0" counter drop comment "Drop all other unsolicited traffic from wan"
          }
          chain forward {
            type filter hook forward priority filter; policy drop;
            iifname { "enp2s0" } oifname { "enp1s0" } accept comment "Allow trusted LAN to WAN"
            iifname { "enp1s0" } oifname { "enp2s0" } ct state established, related accept comment "Allow established back to LANs"
          }
        }

        table ip nat {
          chain postrouting {
            type nat hook postrouting priority 100; policy accept;
            oifname "enp1s0" masquerade
          }
        }

        table ip6 filter {
          chain input {
            type filter hook input priority 0; policy drop;
          }
          chain forward {
            type filter hook forward priority 0; policy drop;
          }
        }
      '';
    };
  };

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