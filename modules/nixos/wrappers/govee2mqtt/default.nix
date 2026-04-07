{
  lib,
  config,
  properties,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab;
let
  cfg = config.nix-homelab.wrappers.govee2mqtt;
  port = properties.ports.mosquitto;
in
{
  options.nix-homelab.wrappers.govee2mqtt = with types; {
    enable = mkEnableOption (lib.mdDoc "Govee2Mqtt");
  };
  config = mkIf cfg.enable {
    services = {
      mosquitto = {
        enable = true;
        listeners = [
          {
            port = port;
            users.mosquitto = {
              acl = [ "readwrite #" ];
              passwordFile = config.sops.secrets.mosquitto_password.path;
            };
            omitPasswordAuth = true;
            settings.allow_anonymous = true;
          }
        ];
      };
      govee2mqtt = {
        # See https://github.com/wez/govee2mqtt/pull/650
        package = pkgs.nix-homelab.govee2mqtt;
        enable = true;
        environmentFile = config.sops.secrets.govee2mqtt_env.path;
      };
    };
    networking.firewall.allowedTCPPorts = [ port ];
    systemd = {
      tmpfiles.rules = [
        "Z  /etc/mosquitto  -  mosquitto  mosquitto -   - "
      ];
      services.govee2mqtt = {
        after = [ "adguardhome.service" ];
        wants = [ "adguardhome.service" ];
        preStart = ''
          ${pkgs.coreutils-full}/bin/sleep 10
        '';
      };
    };
  };
}
