{ config, pkgs, ... }:
let
  port = 2342;
in
{
  services.photoprism.enable = true;
  services.photoprism.originalsPath = "/photos";
  networking.firewall.allowedTCPPorts = [ port ];
}
