{
  pkgs,
  config,
  properties,
  lib,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.server.netdata;
  port = properties.ports.netdata;
  app-name = "netdata";
in {
  options.nix-homelab.server.netdata = with types; {
    enable = mkEnableOption (lib.mdDoc "Netdata monitoring/alerting");
  };
  config = mkIf cfg.enable {
    services.caddy.virtualHosts = {
      "netdata.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-hypervisor.local.ip}:${toString properties.ports.netdata}
        '';
      };
    };
    services.gatus.settings.endpoints = [
      {
        name = "Netdata";
        url = "https://netdata.${properties.network.domain}/";
        conditions = [
          "[STATUS] == 200"
        ];
        alerts = [
          {
            type = "gotify";
          }
        ];
      }
    ];
    networking.firewall.allowedTCPPorts = [port];
    services.netdata = {
      enable = true;
      package = pkgs.netdataCloud;
      config = {
        global = {
          "update every" = 5;
        };
        ml = {
          enabled = "no";
        };
        logs = {
          "debug log" = "none";
          "error log" = "none";
          "access log" = "none";
        };
        registry = {
          "registry to announce" = "https://${app-name}.${properties.network.domain}/";
        };
      };
      configDir."health_alarm_notify.conf" = config.sops.secrets.netdata_alarm.path;
    };
  };
}
