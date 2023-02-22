{ config, lib, pkgs, ... }:
let
  network = import ../../../share/network.properties.nix;
in
{
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ network.localhost "0.0.0.0" ];
        access-control = [
          "127.0.0.0/8 allow"
          "${network.lan1-address} allow"
          "${network.lan2-address} allow"
          "${network.lan3-address} allow"
        ];
      };
    };
  };
}