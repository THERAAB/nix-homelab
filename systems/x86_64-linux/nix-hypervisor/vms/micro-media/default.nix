{...}: {
  imports = [
    ../../../../../share/optional/media.nix
    ./jellyfin.nix
    ./jellyseerr.nix
    ./audiobookshelf.nix
    ./hardware.nix
  ];
}
