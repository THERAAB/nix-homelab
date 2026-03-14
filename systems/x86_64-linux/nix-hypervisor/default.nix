{
  self,
  properties,
  ...
}: {
  imports = [
    (self + /share/nixos/server)
    ./hardware.nix
    ./sops.nix
    ./syncthing.nix
    ./restic.nix
    ./update-flake.nix
    ./home-assistant
    ./adguard.nix
    ./homer.nix
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
      homer.enable = true;
      gotify.enable = true;
      unifi.enable = true;
      beszel-hub.enable = true;
      beszel-agent.enable = true;
      olivetin.enable = true;
      miniflux.enable = true;
    };
    media.enable = true;
  };
  services.netdata.config.registry.enabled = "yes";
  users.users.raab.extraGroups = ["syncthing" "media"];
  networking.firewall.allowedTCPPorts = [properties.ports.http properties.ports.ssl];
  services.caddy = {
    enable = true;
    virtualHosts = {
      "adguard-tailscale.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-nas.local.ip}:${toString properties.ports.adguard}
        '';
      };
      "sync.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-hypervisor.local.ip}:${toString properties.ports.syncthing}
        '';
      };
    };
  };
}
