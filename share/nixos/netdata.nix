{
  pkgs,
  config,
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
  };
  systemd.services.netdata-write-gotify-conf = {
    script = ''
      NOTIFY_CONF_DIR=/etc/netdata/conf.d
      GOTIFY_TOKEN=`cat ${config.sops.secrets.gotify_gatus_token.path}`
      echo SEND_GOTIFY="YES" > $NOTIFY_CONF_DIR
      echo GOTIFY_APP_URL="https://gotify.${network.domain}/" >> $NOTIFY_CONF_DIR
      echo GOTIFY_TOKEN="$GOTIFY_TOKEN" >> $NOTIFY_CONF_DIR
    '';
    wantedBy = ["netdata.service"];
    after = ["netdata.service"];
  };
}
