{ config, pkgs, ... }:
{
  imports = [
    ./home-assistant
    ./homer
    ./media
    ./gatus
    ./adguard.nix
    ./persist.nix
    ./boot.nix
    ./hardware.nix
    ./users.nix
    ./system.nix
    ./pkgs.nix
    ./caddy.nix
    ./netdata.nix
    ./sops.nix
  ];
}
