{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./unbound.nix
    ./networking.nix
    ./dnsmasq.nix
    ./avahi.nix
  ];
}
