{...}: let
  custom-blueprints-dir = "/var/lib/hass/blueprints/automation/custom/";
  system-blueprints-dir = "/nix/persist/nix-homelab/hosts/nix-server/nixos/home-assistant/blueprints";
  port = 8123;
  app-name = "home-assistant";
  display-name = "Home Assistant";
  network = import ../../../../../../share/network.properties.nix;
in {
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
  systemd.tmpfiles.rules = [
    "R  ${custom-blueprints-dir}            -       -       -       -   -                           "
    "L  ${custom-blueprints-dir}            -       -       -       -   ${system-blueprints-dir}    "
    "Z  ${custom-blueprints-dir}            -       hass    hass    -   -                           "
    "Z  /var/lib/hass/blueprints            -       hass    hass    -   -                           "
    "Z  /var/lib/hass/custom_components     -       hass    hass    -   -                           "
  ];
  networking.firewall.allowedTCPPorts = [port];
  services = {
    yamlConfigMaker.gatus.settings.endpoints = [
      {
        name = "${display-name}";
        url = "https://${app-name}.${network.domain}/";
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<title>Home Assistant</title>*)''
        ];
        alerts = [
          {
            type = "gotify";
          }
        ];
      }
    ];
    olivetin.settings.actions = [
      {
        title = "Restart ${display-name}";
        icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
        shell = "sudo /var/lib/olivetin/scripts/commands.sh -s ${app-name}";
        timeout = 20;
      }
    ];
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