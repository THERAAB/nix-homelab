{
  config,
  properties,
  ...
}: let
  port = properties.ports.mosquitto;
in {
  services = {
    mosquitto = {
      enable = true;
      listeners = [
        {
          port = port;
          users.mosquitto = {
            acl = ["readwrite #"];
            passwordFile = config.sops.secrets.mosquitto_password.path;
          };
          omitPasswordAuth = true;
          settings.allow_anonymous = true;
        }
      ];
    };
    govee2mqtt = {
      enable = true;
      environmentFile = config.sops.secrets.govee2mqtt_env.path;
    };
  };
  networking.firewall.allowedTCPPorts = [port];
  systemd = {
    tmpfiles.rules = [
      "Z  /etc/mosquitto  -  mosquitto  mosquitto -   - "
    ];
    services.govee2mqtt = {
      after = ["adguardhome.service"];
      wants = ["adguardhome.service"];
    };
  };
}
