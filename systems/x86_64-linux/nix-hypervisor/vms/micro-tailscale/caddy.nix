{...}: let
  network = import ../../../../../assets/properties/network.properties.nix;
in {
  networking.firewall.allowedTCPPorts = [80 443];
  services.caddy = {
    enable = true;
    virtualHosts = {
      "unifi.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-infra.local.ip}:8443 {
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
          reverse_proxy ${network.micro-tailscale.local.ip}:3000
        '';
      };
      "vuetorrent.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-download.local.ip}:8112
        '';
      };
      "gotify.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-infra.local.ip}:8238
        '';
      };
      "gatus.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-infra.local.ip}:7000
        '';
      };
      "photos.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-server.local.ip}:2342
        '';
      };
      "microbin.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-server.local.ip}:9080
        '';
      };
      "bookmarks.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-server.local.ip}:9090
        '';
      };
      "cache.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.nix-hypervisor.tailscale.ip}:5000
        '';
      };
      "netdata.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.nix-hypervisor.tailscale.ip}:19999
        '';
      };
      "home-assistant.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-automate.local.ip}:8123
        '';
      };
      "sync.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.nix-hypervisor.tailscale.ip}:8384
        '';
      };
      "olivetin.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.nix-hypervisor.tailscale.ip}:1337
        '';
      };
      "notes.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-server.local.ip}:9092
        '';
      };
      "files.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-server.local.ip}:9940
        '';
      };
      "jellyfin.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-media.local.ip}:8096
        '';
      };
      "jellyseerr.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-media.local.ip}:5055
        '';
      };
      "adguard.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-infra.local.ip}:3000
        '';
      };
      "${network.domain}" = {
        useACMEHost = "${network.domain}-tld";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-infra.local.ip}:8082
        '';
      };
      "audiobooks.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-media.local.ip}:13379
        '';
      };
      "prowlarr.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-download.local.ip}:9696
        '';
      };
      "movies.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-download.local.ip}:7878
        '';
      };
      "readarr.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-download.local.ip}:8787
        '';
      };
      "tv.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-download.local.ip}:8989
        '';
      };
    };
  };
}
