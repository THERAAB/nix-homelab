{ config, pkgs, ... }:
{
  imports = [
    ./home-assistant
    ./homer
    ./media
    ./gatus
    ./olivetin
    ./adguard
    ./persist.nix
    ./boot.nix
    ./hardware.nix
    ./users.nix
    ./system.nix
    ./pkgs.nix
    ./caddy.nix
    ./netdata.nix
    ./sops.nix
    ./auto-upgrade.nix
  ];
}
