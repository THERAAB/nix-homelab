{ config, pkgs, lib, ... }:
let
  custom-blueprints-dir = "/var/lib/hass/blueprints/automation/custom/";
  port = 8123;
in
{
  imports = [
    ./kasa-living-room-light.nix
    ./aqara-water-alarms.nix
    ./battery-notifications.nix
    ./govee-immersion.nix
  ];

  systemd.tmpfiles.rules = [
    "R  ${custom-blueprints-dir}            -       -       -       -   -                                                           "
    "C  ${custom-blueprints-dir}            -       -       -       -   /nix/persist/nix-homelab/system/home-assistant/blueprints   "
    "Z  ${custom-blueprints-dir}            770     hass    hass    -   -                                                           "
    "Z  /var/lib/hass/custom_components     770     hass    hass    -   -                                                           "
  ];

  services.caddy.virtualHosts = {
    "http://home-assistant.server.box".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://home-assistant.server.tail".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  networking.firewall.allowedTCPPorts = [ port ];
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
    ];
    config = {
      default_config = {};
      http = {
        trusted_proxies = [ "127.0.0.1" ];
        use_x_forwarded_for = true;
      };
      homeassistant = {
        name = "Home";
        unit_system = "imperial";
        time_zone = "America/New_York";
        temperature_unit = "F";
        longitude = "!secret longitude";
        latitude = "!secret latitude";
      };
    };
  };
}