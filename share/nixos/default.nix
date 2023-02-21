{ config, pkgs, ... }:
{
  imports = [
    ./podman.nix
    ./persist.nix
    ./system.nix
    ./pkgs.nix
    ./sops.nix
    ./auto-upgrade.nix
    ./configuration.nix
    ./users.nix
  ];
}
