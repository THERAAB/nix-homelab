{
  network,
  ports,
  ...
}: {
  networking.firewall.allowedTCPPorts = [ports.http ports.ssl];
  services.caddy = {
    enable = true;
    virtualHosts = {
      "unifi.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-infra.local.ip}:${toString ports.unifi} {
            transport http {
              tls_insecure_skip_verify
            }
          }
        '';
      };
      "adguard-tailscale.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-tailscale.local.ip}:${toString ports.adguard}
        '';
      };
      "vuetorrent.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-download.local.ip}:${toString ports.vuetorrent}
        '';
      };
      "gotify.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-infra.local.ip}:${toString ports.gotify}
        '';
      };
      "gatus.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-infra.local.ip}:${toString ports.gatus}
        '';
      };
      "photos.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-server.local.ip}:${toString ports.photoprism}
        '';
      };
      "microbin.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-server.local.ip}:${toString ports.microbin}
        '';
      };
      "bookmarks.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-server.local.ip}:${toString ports.linkding}
        '';
      };
      "cache.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.nix-hypervisor.tailscale.ip}:${toString ports.harmonia}
        '';
      };
      "netdata.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.nix-hypervisor.tailscale.ip}:${toString ports.netdata}
        '';
      };
      "home-assistant.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-automate.local.ip}:${toString ports.home-assistant}
        '';
      };
      "sync.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.nix-hypervisor.tailscale.ip}:${toString ports.syncthing}
        '';
      };
      "olivetin.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.nix-hypervisor.tailscale.ip}:${toString ports.olivetin}
        '';
      };
      "notes.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-server.local.ip}:${toString ports.flatnotes}
        '';
      };
      "files.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-server.local.ip}:${toString ports.filebrowser}
        '';
      };
      "jellyfin.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-media.local.ip}:${toString ports.jellyfin}
        '';
      };
      "jellyseerr.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-media.local.ip}:${toString ports.jellyseerr}
        '';
      };
      "adguard.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-infra.local.ip}:${toString ports.adguard}
        '';
      };
      "${network.domain}" = {
        useACMEHost = "${network.domain}-tld";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-infra.local.ip}:${toString ports.homer}
        '';
      };
      "audiobooks.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-media.local.ip}:${toString ports.audiobookshelf}
        '';
      };
      "prowlarr.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-download.local.ip}:${toString ports.prowlarr}
        '';
      };
      "movies.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-download.local.ip}:${toString ports.radarr}
        '';
      };
      "readarr.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-download.local.ip}:${toString ports.readarr}
        '';
      };
      "tv.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-download.local.ip}:${toString ports.sonarr}
        '';
      };
    };
  };
}
