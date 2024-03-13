{properties, ...}: let
  custom-blueprints-dir = "/var/lib/hass/blueprints/automation/custom";
  local-config-dir = "/var/lib/hass";
  system-blueprints-dir = "/nix/persist/nix-homelab/systems/x86_64-linux/micro-automate/home-assistant/blueprints";
  port = properties.ports.home-assistant;
  app-name = "hass";
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
  microvm = {
    devices = [
      {
        bus = "pci";
        path = "0000:00:14.0"; # Passthrough whole USB bus because single usb device passthrough doesn't work
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        source = system-blueprints-dir;
        mountPoint = custom-blueprints-dir;
        tag = "custom-blueprints";
      }
    ];
  };
  users.users.hass.uid = properties.users.hass.uid;
  systemd = {
    tmpfiles.rules = [
      "R  ${local-config-dir}/secrets.yaml          -       -             -              -   -                           "
      "C  ${local-config-dir}/secrets.yaml          -       -             -              -   /run/secrets/home_assistant "
      "Z  ${custom-blueprints-dir}                  -       ${app-name}   ${app-name}    -   -                           "
      "Z  ${local-config-dir}/blueprints            -       ${app-name}   ${app-name}    -   -                           "
      "Z  ${local-config-dir}/custom_components     -       ${app-name}   ${app-name}    -   -                           "
      "Z  ${local-config-dir}                       -       ${app-name}   ${app-name}    -   -                           "
    ];
  };
  networking.firewall.allowedTCPPorts = [port];
  services.home-assistant = {
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
        trusted_proxies = ["127.0.0.1" properties.network.micro-tailscale.local.ip];
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
          resource = "https://gotify.${properties.network.domain}/message";
          method = "POST_JSON";
          headers.X-Gotify-Key = "!secret gotify_ha_token";
          message_param_name = "message";
          title_param_name = "title";
        }
      ];
    };
  };
}
