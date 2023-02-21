{ config, pkgs, ... }:
{
  imports = [
    ./home-assistant
    ./homer
    ./media
    ./gatus
    ./olivetin
    ./adguard
    ./hardware-configuration.nix
    ./boot.nix
    ./caddy.nix
    ./netdata.nix
    ./users.nix
    ./hardware.nix
    ./sops.nix
  ];
}
