{ config, pkgs, ... }:
{
  # Adding netavark to helper binaries so podman health check stops failing
  virtualisation = {
    podman.extraPackages = [ pkgs.netavark ];
    containers.containersConf.settings.engine.helper_binaries_dir = ["${pkgs.netavark}/bin"];
  };
}