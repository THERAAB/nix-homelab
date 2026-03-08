{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.gatus;
  port = properties.ports.gatus;
  network = properties.network;
  dns-port = 53;
in {
  options.nix-homelab.wrappers.gatus = with types; {
    enable = mkEnableOption (lib.mdDoc "Gatus");
  };
  config = mkIf cfg.enable {
    services.gatus = {
      openFirewall = true;
      enable = true;
      settings = {
        web.port = port;
        alerting = {
          gotify = {
            server-url = "https://gotify.${network.domain}";
            token = "$GOTIFY_SECRET";
            body = ''{"type":"note","title":"Gatus [ALERT_TRIGGERED_OR_RESOLVED]: [ENDPOINT_NAME]","body":"[ALERT_DESCRIPTION] - [ENDPOINT_URL]"}'';
            default-alert = {
              description = "Status Change";
              send-on-resolved = true;
              failure-threshold = 5;
              success-thershold = 3;
            };
          };
        };
        endpoints = [
          {
            name = "Harmonia Cache";
            url = "https://cache.${network.domain}/";
            conditions = [
              "[STATUS] == 200"
              ''[BODY] == pat(*<title>*harmonia*</title>*)''
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Immich";
            url = "https://photos.${network.domain}/";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Olivetin";
            url = "https://olivetin.${network.domain}/";
            conditions = [
              "[STATUS] == 200"
              ''[BODY] == pat(*<title>OliveTin</title>*)''
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "BentoPdf";
            url = "https://pdf.${network.domain}/";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Linkwarden";
            url = "https://bookmarks.${network.domain}/";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Netdata";
            url = "https://netdata.${network.domain}/";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "SyncThing";
            url = "https://sync.${network.domain}/";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Home Assistant";
            url = "https://home-assistant.${network.domain}/";
            conditions = [
              "[STATUS] == 200"
              ''[BODY] == pat(*<title>Home Assistant</title>*)''
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Unifi Network Application";
            url = "https://unifi.${network.domain}";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
            client.insecure = true;
          }
          {
            name = "Gotify";
            url = "https://gotify.${network.domain}/";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Vuetorrent";
            url = "https://vuetorrent.${network.domain}/";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Sonarr";
            url = "https://tv.${network.domain}/health";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Flaresolverr";
            url = "https://flaresolverr.${network.domain}/health";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Radarr";
            url = "https://movies.${network.domain}/health";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Prowlarr";
            url = "https://prowlarr.${network.domain}/health";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Jellyseerr";
            url = "https://jellyseerr.${network.domain}/health";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Jellyfin";
            url = "https://jellyfin.${network.domain}/health";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Audiobookshelf";
            url = "https://audiobooks.${network.domain}/";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Homer";
            url = "https://${network.domain}/";
            conditions = [
              "[STATUS] == 200"
              ''[BODY] == pat(*<div id="app-mount"></div>*)''
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Adguard";
            url = "https://adguard.${network.domain}/";
            conditions = [
              "[STATUS] == 200"
              ''[BODY] == pat(*<title>Login</title>*)''
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Beszel";
            url = "https://beszel.${network.domain}/";
            conditions = [
              "[STATUS] == 200"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Adguard Tailscale";
            url = "https://adguard-tailscale.${network.domain}/";
            conditions = [
              "[STATUS] == 200"
              ''[BODY] == pat(*<title>Login</title>*)''
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Govee Water Alarm";
            url = "tcp://${network.govee-water-alarm.local.ip}:${toString dns-port}";
            conditions = [
              "[RESPONSE_TIME] < 500"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Ring Doorbell";
            url = "tcp://${network.ring-doorbell.local.ip}:${toString dns-port}";
            conditions = [
              "[RESPONSE_TIME] < 2500"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Ecobee Thermostat";
            url = "tcp://${network.ecobee.local.ip}:${toString dns-port}";
            conditions = [
              "[RESPONSE_TIME] < 500"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Unifi U6+";
            url = "tcp://${network.unifi-u6-plus.local.ip}:${toString dns-port}";
            conditions = [
              "[RESPONSE_TIME] < 500"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Unifi Lite 8 Switch";
            url = "tcp://${network.unifi-usw-lite-8.local.ip}:${toString dns-port}";
            conditions = [
              "[RESPONSE_TIME] < 500"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
          {
            name = "Nix-Nas";
            url = "udp://${network.nix-nas.local.ip}:${toString dns-port}";
            conditions = [
              "[RESPONSE_TIME] < 500"
            ];
            alerts = [
              {
                type = "gotify";
              }
            ];
          }
        ];
      };
      environmentFile = config.sops.secrets.gatus_env.path;
    };
  };
}
