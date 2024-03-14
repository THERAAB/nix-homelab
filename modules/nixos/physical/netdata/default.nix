{
  pkgs,
  config,
  properties,
  lib,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical.netdata;
  port = properties.ports.netdata;
  app-name = "netdata";
in {
  options.nix-homelab.physical.netdata = with types; {
    enable = mkEnableOption (lib.mdDoc "Netdata monitoring/alerting");
  };
  config = mkIf cfg.enable {
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
