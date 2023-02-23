{ config, lib, pkgs, ... }:
let
  network = import ../../../share/network.properties.nix;
in
{
  services.dnsmasq = {
    settings = {
      # TODO: point to adguard
      server = [ "8.8.8.8" ];
      interface = [ network.lan-interfaces ];
      domain-needed = true;
      dhcp-range = [ "10.10.11.100,10.10.11.254,24h" "10.10.12.100,10.10.12.254,24h" "10.10.13.100,10.10.13.254,24h" ];
      dhcp-host = [
        "${network.nix-server.mac},${network.nix-server.local.ip}"
        "${network.desktop.mac},${network.desktop.local.ip}"
      ];
    };
  };
}