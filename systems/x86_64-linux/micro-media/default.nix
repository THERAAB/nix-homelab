{config, ...}: {
  imports = [
    ./hardware.nix
  ];
  nix-homelab = {
    core.enable = true;
    media.enable = true;
    wrappers = {
      audiobookshelf.enable = true;
      jellyfin.enable = true;
      jellyseerr.enable = true;
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
  microvm.devices = [
    {
      bus = "pci";
      path = "0000:00:02.0";
    }
  ];
}
