{...}: let
  devices = import ./devices.properties.nix;
in {
  services.home-assistant.config = {
    adaptive_lighting = {
      lights = [
        devices.entity-id.bathroom.lights
      ];
      separate_turn_on_commands = true;
      transition = 0;
      interval = 15;
      initial_transition = 1;
      min_brightness = 25;
      max_brightness = 100;
      min_color_temp = 1000;
      max_color_temp = 4000;
      sleep_brightness = 10;
      sleep_color_temp = 1000;
    };
    automation = [
      {
        alias = "Turn on Bathroom lights when motion detected";
        trigger = {
          platform = "state";
          entity_id = devices.entity-id.bathroom.motion;
          from = "off";
          to = "on";
        };
        action = [
          {
            "if" = {
              condition = "time";
              before = "8:00:00";
              after = "20:00:00";
            };
            "then" = {
              service = "switch.turn_on";
              target.entity_id = [
                "switch.adaptive_lighting_sleep_mode_adaptive_bathroom_lights"
              ];
            };
            "else" = {
              service = "switch.turn_off";
              target.entity_id = [
                "switch.adaptive_lighting_sleep_mode_adaptive_bathroom_lights"
              ];
            };
          }
          {
            service = "light.turn_on";
            target.entity_id = [
              devices.entity-id.bathroom.lights
            ];
          }
          {
            wait_for_trigger = {
              platform = "state";
              entity_id = devices.entity-id.bathroom.motion;
              from = "on";
              to = "off";
              for = {
                seconds = 300;
              };
            };
          }
          {
            repeat = {
              while = {
                condition = "numeric_state";
                entity_id = devices.entity-id.bathroom.humidity;
                above = 80;
              };
              sequence = {
                delay = {
                  seconds = 30;
                };
              };
            };
          }
          {
            service = "light.turn_off";
            target.entity_id = [
              devices.entity-id.bathroom.lights
            ];
          }
        ];
      }
    ];
  };
}
