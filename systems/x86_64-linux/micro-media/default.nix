{...}: {
  imports = [
    ./hardware.nix
  ];
  nix-homelab = {
    media.enable = true;
    services = {
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
