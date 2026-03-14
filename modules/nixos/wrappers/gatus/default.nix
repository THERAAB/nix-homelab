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
    services.caddy.virtualHosts = {
      "gatus.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-hypervisor.local.ip}:${toString properties.ports.gatus}
        '';
      };
    };
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
            name = "SyncThing";
            url = "https://sync.${properties.network.domain}/";
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
            url = "https://adguard-tailscale.${properties.network.domain}/";
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
          # TODO: update
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
            name = "Reolink Doorbell";
            url = "tcp://${network.reolink-doorbell.local.ip}:${toString dns-port}";
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
