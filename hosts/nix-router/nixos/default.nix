{ config, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./hardware-configuration.nix
  ];
}
