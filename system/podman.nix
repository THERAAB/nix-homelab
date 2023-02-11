{ config, pkgs, ... }:
{
  virtualisation.podman.extraPackages = [
    pkgs.netavark
  ];
  virtualisation.containers.containers.Conf.settings = {
    engine = {
      helper_binaries_dir = "${pkgs.netavark}\bin";
    };
  };
}