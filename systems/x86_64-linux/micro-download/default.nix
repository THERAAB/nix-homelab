{...}: {
  imports = [
    ./vuetorrent.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./readarr.nix
    ./hardware.nix
  ];
  nix-homelab.media.enable = true;
}
