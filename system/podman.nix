{ config, pkgs, ... }:
{
  virtualisation.podman.extraPackages = [
    pkgs.netavark
  ];
}