{self, ...}: {
  imports = [
    (self + /share/optional/media.nix)
    ./vuetorrent.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./readarr.nix
    ./hardware.nix
  ];
}
