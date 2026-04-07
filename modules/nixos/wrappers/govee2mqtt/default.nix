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
        # package = pkgs.govee2mqtt.overrideAttrs (oldAttrs: {
        #   src = pkgs.fetchFromGitHub {
        #     owner = "wez";
        #     repo = "govee2mqtt";
        #     tag = "2026.03.25-ab9deb66";
        #     hash = "sha256-APGvE5BIYgZtAWbM9DGJFuGyI3715g8Gyxou8uhspdM=";
        #   };
        #   prePatch = ''
        #     substituteInPlace src/undoc_api.rs \
        #         --replace '"6.5.02"' '"7.4.10"'
        #     substituteInPlace src/undoc_api.rs \
        #         --replace 'iOS 16.5.0) Alamofire/5.6.4' 'iOS 18.4.0) Alamofire/5.10.2'
        #   '';
        #   cargoHash = "sha256-XIdWxhyARhAHV0IZXOHOl4mHFS5/4Is74B4615jYeDs=";
        # });
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
