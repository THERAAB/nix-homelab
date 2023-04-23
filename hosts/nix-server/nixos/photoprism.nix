{ config, pkgs, ... }:
let
  port = 2342;
in
{
  services.photoprism.enable = true;
  networking.firewall.allowedTCPPorts = [ port ];
}
