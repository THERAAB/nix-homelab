{...}: {
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
}
