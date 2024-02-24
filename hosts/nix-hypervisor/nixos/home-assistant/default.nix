{...}: let
  custom-blueprints-dir = "/var/lib/hass/blueprints/automation/custom/";
  system-blueprints-dir = "/nix/persist/nix-homelab/hosts/nix-hypervisor/nixos/home-assistant/blueprints";
  port = 8123;
  app-name = "home-assistant";
  network = import ../../../../share/network.properties.nix;
  users = import ../../../../share/users.properties.nix;
in {
  #TODO: move to micro-server, delay start
  imports = [
    ./kasa-living-room-light.nix
    ./aqara-water-alarms.nix
    ./battery-notifications.nix
    ./govee-immersion.nix
    ./shopping-list.nix
    ./tapo-light-strip.nix
    ./bathroom-lights.nix
    ./washer-dryer.nix
  ];
  users.users.hass.uid = users.hass.uid;
  systemd = {
    tmpfiles.rules = [
      "R  ${custom-blueprints-dir}            -       -       -       -   -                           "
      "C  ${custom-blueprints-dir}            -       -       -       -   ${system-blueprints-dir}    "
      "Z  ${custom-blueprints-dir}            -       hass    hass    -   -                           "
      "Z  /var/lib/hass/blueprints            -       hass    hass    -   -                           "
      "Z  /var/lib/hass/custom_components     -       hass    hass    -   -                           "
      "Z  /var/lib/hass/                      -       hass    hass    -   -                           "
    ];
  };
  networking.firewall.allowedTCPPorts = [port];
  services = {
    caddy.virtualHosts."${app-name}.${network.domain}" = {
      useACMEHost = "${network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
    home-assistant = {
      enable = true;
      extraComponents = [
        "met"
        "radio_browser"
        "backup"
        "zha"
        "zwave_js"
        "tplink"
        "github"
        "ifttt"
        "androidtv"
        "assist_pipeline"
        "ffmpeg"
        "tuya"
        "ecobee"
        "sharkiq"
      ];
      config = {
        default_config = {};
        http = {
          trusted_proxies = ["127.0.0.1"];
          use_x_forwarded_for = true;
        };
        homeassistant = {
          name = "Home";
          unit_system = "imperial";
          time_zone = "America/New_York";
          temperature_unit = "F";
          longitude = "!secret home_longitude";
          latitude = "!secret home_latitude";
        };
        notify = [
          {
            name = "gotify";
            platform = "rest";
            resource = "https://gotify.${network.domain}/message";
            method = "POST_JSON";
            headers.X-Gotify-Key = "!secret gotify_ha_token";
            message_param_name = "message";
            title_param_name = "title";
          }
        ];
      };
    };
  };
}
