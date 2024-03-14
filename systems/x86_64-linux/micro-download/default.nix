{...}: {
  imports = [
    ./hardware.nix
  ];
  nix-homelab = {
    media.enable = true;
    wrappers = {
      prowlarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      readarr.enable = true;
      vuetorrent.enable = true;
    };
  };
}
