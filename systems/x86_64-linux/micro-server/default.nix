{config, ...}: let
  originals-dir = "/var/lib/private/photoprism/originals";
in {
  imports = [
    ./hardware.nix
  ];
  nix-homelab = {
    core = {
      flakes.enable = true;
      system.enable = true;
    };
    wrappers = {
      filebrowser.enable = true;
      flatnotes.enable = true;
      linkding.enable = true;
      microbin.enable = true;
      photoprism.enable = true;
    };
    microvm = {
      podman.enable = true;
      system.enable = true;
      hardware = {
        enable = true;
        hostName = config.networking.hostName;
      };
    };
  };
  microvm.shares = [
    {
      proto = "virtiofs";
      source = "/sync/Camera";
      mountPoint = "${originals-dir}";
      tag = "Camera";
    }
  ];
}
