{...}: {
  imports = [
    ./nfs.nix
    ./jellyfin.nix
    ./vuetorrent.nix
    ./jellyseerr.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./audiobookshelf.nix
    ./readarr.nix
    ./hardware.nix
    ./users.nix
  ];
}
