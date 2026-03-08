{self, ...}: {
  imports = [
    (self + /share/nixos/server)
    ./hardware.nix
    ./sops.nix
    ./syncthing.nix
    ./restic.nix
    ./update-flake.nix
    ./home-assistant
    ./caddy.nix
    ./adguard.nix
    ./olivetin
  ];
  nix-homelab = {
    server = {
      enable = true;
      podman.enable = true;
    };
    networking.harmonia.enable = true;
    networking.acme.enable = true;
    wrappers = {
      radarr.enable = true;
      prowlarr.enable = true;
      sonarr.enable = true;
      flaresolverr.enable = true;
      vuetorrent.enable = true;
      audiobookshelf.enable = true;
      jellyfin.enable = true;
      jellyseerr.enable = true;
      home-assistant.enable = true;
      bentopdf.enable = true;
      immich.enable = true;
      linkwarden.enable = true;
      gatus.enable = true;
      homer = {
        enable = true;
        conf = import ./homer.nix;
      };
      gotify.enable = true;
      unifi.enable = true;
    };
    media.enable = true;
  };
  services.netdata.config.registry.enabled = "yes";
  users.users.raab.extraGroups = ["syncthing" "media"];
}
