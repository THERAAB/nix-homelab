{self, ...}: {
  imports = [
   # (self + /share/nixos/microvm)
    ./hardware.nix
  ];
  nix-homelab = {
    microvm.enable = true;
    media.enable = true;
    wrappers = {
      audiobookshelf.enable = true;
      jellyfin.enable = true;
      jellyseerr.enable = true;
    };
  };
}
