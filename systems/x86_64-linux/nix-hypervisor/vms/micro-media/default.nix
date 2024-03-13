{self, ...}: {
  imports = [
    (self + /share/optional/media.nix)
    ./jellyfin.nix
    ./jellyseerr.nix
    ./audiobookshelf.nix
    ./hardware.nix
  ];
}
