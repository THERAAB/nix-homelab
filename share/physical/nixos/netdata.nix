{
  pkgs,
  config,
  properties,
  ...
}: let
  port = properties.ports.netdata;
  app-name = "netdata";
in {
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
}
