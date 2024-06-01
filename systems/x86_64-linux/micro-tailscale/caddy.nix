{properties, ...}: {
  networking.firewall.allowedTCPPorts = [properties.ports.http properties.ports.ssl];
  services.caddy = {
    enable = true;
    virtualHosts = {
      "unifi.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-infra.local.ip}:${toString properties.ports.unifi} {
            transport http {
              tls_insecure_skip_verify
            }
          }
        '';
      };
      "adguard-tailscale.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-tailscale.local.ip}:${toString properties.ports.adguard}
        '';
      };
      "vuetorrent.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-download.local.ip}:${toString properties.ports.vuetorrent}
        '';
      };
      "gotify.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-infra.local.ip}:${toString properties.ports.gotify}
        '';
      };
      "gatus.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-infra.local.ip}:${toString properties.ports.gatus}
        '';
      };
      "photos.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-server.local.ip}:${toString properties.ports.photoprism}
        '';
      };
      "microbin.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-server.local.ip}:${toString properties.ports.microbin}
        '';
      };
      "bookmarks.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-server.local.ip}:${toString properties.ports.linkding}
        '';
      };
      "cache.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-hypervisor.tailscale.ip}:${toString properties.ports.harmonia}
        '';
      };
      "netdata.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-hypervisor.tailscale.ip}:${toString properties.ports.netdata}
        '';
      };
      "home-assistant.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-automate.local.ip}:${toString properties.ports.home-assistant}
        '';
      };
      "sync.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-hypervisor.tailscale.ip}:${toString properties.ports.syncthing}
        '';
      };
      "olivetin.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-hypervisor.tailscale.ip}:${toString properties.ports.olivetin}
        '';
      };
      "notes.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-server.local.ip}:${toString properties.ports.flatnotes}
        '';
      };
      "files.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-server.local.ip}:${toString properties.ports.filebrowser}
        '';
      };
      "jellyfin.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-media.local.ip}:${toString properties.ports.jellyfin}
        '';
      };
      "jellyseerr.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-media.local.ip}:${toString properties.ports.jellyseerr}
        '';
      };
      "adguard.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-infra.local.ip}:${toString properties.ports.adguard}
        '';
      };
      "${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}-tld";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-infra.local.ip}:${toString properties.ports.homer}
        '';
      };
      "audiobooks.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-media.local.ip}:${toString properties.ports.audiobookshelf}
        '';
      };
      "prowlarr.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-download.local.ip}:${toString properties.ports.prowlarr}
        '';
      };
      "movies.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-download.local.ip}:${toString properties.ports.radarr}
        '';
      };
      "readarr.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-download.local.ip}:${toString properties.ports.readarr}
        '';
      };
      "tv.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.micro-download.local.ip}:${toString properties.ports.sonarr}
        '';
      };
    };
  };
}
