{...}: let
  originals-dir = "/var/lib/private/photoprism/originals";
in {
  imports = [
    ./hardware.nix
  ];
  nix-homelab = {
    microvm.enable = true;
    wrappers = {
      filebrowser.enable = true;
      flatnotes.enable = true;
      linkding.enable = true;
      microbin.enable = true;
      photoprism.enable = true;
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
