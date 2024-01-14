{
  pkgs,
  ...
}: let
  port = 19999;
  app-name = "netdata";
  network = import ../network.properties.nix;
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
        "registry to announce" = "https://${app-name}.${network.domain}/";
      };
    };
    configDir."health_alarm_notify.conf" = pkgs.writeText "health_alarm_notify.conf" ''
      SEND_GOTIFY="NO"
      GOTIFY_APP_URL="https://gotify.${network.domain}/"
    '';
  };
}
