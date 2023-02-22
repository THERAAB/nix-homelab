{ config, lib, pkgs, ... }:
{
    networking.hostName = "nix-router";
    networking.nftables.enable = true;
}