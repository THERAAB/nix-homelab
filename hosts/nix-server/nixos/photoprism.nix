{ config, pkgs, ... }:
let
  port = 2342;
in
{
  services.photoprism = {
    enable = true;
    originalsPath = "/photos";
    address = "http://192.168.3.2:2342/";
    settings = {
      PHOTOPRISM_ADMIN_PASSWORD = "insecure";
    };
  };
  networking.firewall.allowedTCPPorts = [ port ];
}
