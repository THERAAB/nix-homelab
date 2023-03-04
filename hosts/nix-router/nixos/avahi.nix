{ config, pkgs, ... }:
{
  services.avahi = {
    enable = true;
    reflector = true;
    interfaces = [ "enp2s0" "eno1" "enp4s0" ];
  };
}