{...}: {
  imports = [
    ./hardware.nix
  ];
  nix-homelab = {
    media.enable = true;
    services = {
      prowlarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      readarr.enable = true;
      vuetorrent.enable = true;
    };
  };
}
