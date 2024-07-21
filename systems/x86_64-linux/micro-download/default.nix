{self, ...}: {
  imports = [
    (self + /share/nixos/microvm)
    ./hardware.nix
  ];
  nix-homelab = {
    microvm.enable = true;
    media.enable = true;
    wrappers = {
      prowlarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      readarr.enable = true;
      vuetorrent.enable = true;
      # TODO tdarr.enable = true;
    };
  };
}
