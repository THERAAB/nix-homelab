{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
    # ./networking.nix
  ];
}
