{...}: {
  imports = [
    ./vuetorrent.nix
    ./radarr.nix
    ./sonarr.nix
    ./readarr.nix
    ./hardware.nix
  ];
  nix-homelab = {
    media.enable = true;
    services.prowlarr.enable = true;
  };
}
