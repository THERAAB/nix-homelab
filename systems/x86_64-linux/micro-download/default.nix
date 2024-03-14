{config, ...}: {
  imports = [
    ./hardware.nix
  ];
  nix-homelab = {
    media.enable = true;
    core = {
      flakes.enable = true;
      system.enable = true;
    };
    microvm = {
      podman.enable = true;
      system.enable = true;
      hardware = {
        enable = true;
        hostName = config.networking.hostName;
      };
    };
    wrappers = {
      prowlarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      readarr.enable = true;
      vuetorrent.enable = true;
    };
  };
}
