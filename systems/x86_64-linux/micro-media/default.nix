{...}: {
  imports = [
    ./hardware.nix
  ];
  nix-homelab = {
    microvm.enable = true;
    media.enable = true;
    wrappers = {
      audiobookshelf.enable = true;
      jellyfin.enable = true;
      jellyseerr.enable = true;
    };
  };
  microvm.devices = [
    {
      bus = "pci";
      path = "0000:00:02.0";
    }
  ];
}
