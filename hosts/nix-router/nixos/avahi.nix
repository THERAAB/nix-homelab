{ config, pkgs, ... }:
{
  services.avahi = {
    enable = true;
    reflector = true;
    interfaces = [ "enp2s0" "enp3s0" "enp4s0" ];
  };
}