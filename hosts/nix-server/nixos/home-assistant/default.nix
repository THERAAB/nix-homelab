{...}: let
  custom-blueprints-dir = "/var/lib/hass/blueprints/automation/custom/";
  system-blueprints-dir = "/nix/persist/nix-homelab/hosts/nix-server/nixos/home-assistant/blueprints";
  port = 8123;
  app-name = "home-assistant";
  network = import ../../../../share/network.properties.nix;
in {
  imports = [
    ./kasa-living-room-light.nix
    ./aqara-water-alarms.nix
    ./battery-notifications.nix
    ./govee-immersion.nix
    ./shopping-list.nix
    ./tapo-light-strip.nix
  ];

  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Home Assistant";
      url = "http://${app-name}.${network.domain.local}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>Home Assistant</title>*)''
      ];
      alerts = [
        {
          type = "custom";
        }
      ];
    }
  ];
  services.olivetin.settings.actions = [
    {
      title = "Restart Home Assistant";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -s ${app-name}";
      timeout = 20;
    }
  ];
  systemd.tmpfiles.rules = [
    "R  ${custom-blueprints-dir}            -       -       -       -   -                           "
    "L  ${custom-blueprints-dir}            -       -       -       -   ${system-blueprints-dir}    "
    "Z  ${custom-blueprints-dir}            770     hass    hass    -   -                           "
    "Z  /var/lib/hass/blueprints            770     hass    hass    -   -                           "
    "Z  /var/lib/hass/custom_components     770     hass    hass    -   -                           "
  ];
  services.caddy.virtualHosts = {
    "http://${app-name}.${network.domain.local}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
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
      "pushbullet"
      "wiz"
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
    };
  };
}
