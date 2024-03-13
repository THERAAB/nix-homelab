{...}: {
  imports = [
    ./jellyfin.nix
    ./jellyseerr.nix
    ./audiobookshelf.nix
    ./hardware.nix
  ];
  nix-homelab.media.enable = true;
}
