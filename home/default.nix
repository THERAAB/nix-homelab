{ config, pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./persist.nix
    ./git.nix
    ./pkgs.nix
  ];
}
