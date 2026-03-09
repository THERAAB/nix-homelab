{
  lib,
  config,
  properties,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.home-assistant;
  custom-blueprints-dir = "/var/lib/hass/blueprints/automation/custom";
  local-config-dir = "/var/lib/hass";
  port = properties.ports.home-assistant;
  app-name = "hass";
in {
  options.nix-homelab.wrappers.home-assistant = with types; {
    enable = mkEnableOption (lib.mdDoc "Home Assistant");
  };
  config = mkIf cfg.enable {
    services.caddy.virtualHosts = {
      "home-assistant.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-hypervisor.local.ip}:${toString properties.ports.home-assistant}
        '';
      };
    };
    services.gatus.settings.endpoints = [
      {
        name = "Home Assistant";
        url = "https://home-assistant.${properties.network.domain}/";
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
    users.users.hass.uid = properties.users.hass.uid;
    systemd = {
      tmpfiles.rules = [
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
      customComponents = with pkgs.home-assistant-custom-components; [
        adaptive_lighting
      ];
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
        "isal"
      ];
      config = {
        default_config = {};
        http = {
          trusted_proxies = ["127.0.0.1" properties.network.nix-hypervisor.local.ip];
          use_x_forwarded_for = true;
        };
        homeassistant = {
          name = "Home";
          unit_system = "us_customary";
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
  };
}
