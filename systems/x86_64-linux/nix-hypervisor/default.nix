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
      audiobookrequest.enable = true;
      jellyfin.enable = true;
      jellyseerr.enable = true;
      home-assistant.enable = true;
      bentopdf.enable = true;
      immich.enable = true;
      gatus = {
        enable = true;
        conf = import ./gatus.nix;
      };
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
