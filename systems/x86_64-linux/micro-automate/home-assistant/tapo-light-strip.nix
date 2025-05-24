{pkgs, ...}: let
  devices = import ./devices.properties.nix;
in {
  services.home-assistant = {
    customComponents = [
      # pkgs.nix-homelab.home-assistant-tapo-p100
    ];
    config.automation = [
      {
        alias = "Turn on Kitchen Cabinet LEDs when Motion Detected";
        trigger = {
          platform = "state";
          entity_id = devices.entity-id.kitchen.motion;
          from = "off";
          to = "on";
        };
        condition = {
          condition = "numeric_state";
          entity_id = devices.entity-id.kitchen.illuminence;
          below = "9";
        };
        action = [
          {
            service = "light.turn_on";
            data = {
              brightness_pct = 15;
              color_temp = 300;
            };
            target = {
              entity_id = devices.entity-id.kitchen.cabinet.light;
            };
          }
          {
            wait_for_trigger = {
              platform = "state";
              entity_id = devices.entity-id.kitchen.motion;
              from = "on";
              to = "off";
              for = {
                seconds = 90;
              };
            };
          }
          {
            service = "light.turn_off";
            target = {
              entity_id = devices.entity-id.kitchen.cabinet.light;
            };
          }
        ];
      }
    ];
  };
}
