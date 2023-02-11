{ config, pkgs, ... }:
{
  virtualisation.podman.extraPackages = [
    pkgs.netavark
  ];
  virtualisation.containers.containersConf.settings = {
    engine = {
      helper_binaries_dir = "${pkgs.netavark}/bin";
    };
  };
}