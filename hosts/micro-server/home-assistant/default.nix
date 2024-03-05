{...}: let
  custom-blueprints-dir = "/var/lib/hass/blueprints/automation/custom/";
  system-blueprints-dir = "/nix/persist/nix-homelab/hosts/nix-hypervisor/home-assistant/blueprints";
  port = 8123;
  network = import ../../../share/network.properties.nix;
  users = import ../../../share/users.properties.nix;
in {
  #TODO: delay start, move to micro-server
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
  microvm.devices = [
    {
      bus = "usb";
      path = "vendorid=0x1a86,productid=0x55d4";
    }
  ];
  users.users.hass.uid = users.hass.uid;
  systemd = {
    tmpfiles.rules = [
      "R  ${custom-blueprints-dir}            -       -       -       -   -                           "
      "C  ${custom-blueprints-dir}            -       -       -       -   ${system-blueprints-dir}    "
      "R  /var/lib/hass/secrets.yaml          -       -       -       -   -                           "
      "C  /var/lib/hass/secrets.yaml          -       -       -       -   /run/secrets/home_assistant "
      "z  /var/lib/hass/secrets.yaml          -       hass    hass    -   -                           "
      "Z  ${custom-blueprints-dir}            -       hass    hass    -   -                           "
      "Z  /var/lib/hass/blueprints            -       hass    hass    -   -                           "
      "Z  /var/lib/hass/custom_components     -       hass    hass    -   -                           "
      "Z  /var/lib/hass/                      -       hass    hass    -   -                           "
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
        trusted_proxies = ["127.0.0.1" network.micro-tailscale.tailscale.ip network.micro-tailscale.local.ip];
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
}
