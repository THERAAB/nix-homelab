{...}: let
  devices = import ./devices.properties.nix;
in {
  services.home-assistant.config = {
    adaptive_lighting = [
      {
        name = "bathroom";
        lights = [
          devices.entity-id.bathroom.lights
        ];
        separate_turn_on_commands = true;
        transition = 2;
        interval = 15;
        initial_transition = 1;
        min_brightness = 10;
        max_brightness = 100;
        min_color_temp = 2202;
        max_color_temp = 4000;
        sleep_brightness = 1;
        sleep_color_temp = 2202;
        sunrise_offset = 1800;
        sunset_offset = 1800; # 30min
      }
    ];
    automation = [
      {
        alias = "Switch On Bathroom Adaptive Lighting Sleep Mode at Night";
        trigger = {
          trigger = "time";
          at = "21:30:00";
        };
        action = [
          {
            service = "switch.turn_on";
            target.entity_id = [
              "switch.adaptive_lighting_sleep_mode_bathroom"
            ];
          }
        ];
      }
      {
        alias = "Switch Off Bathroom Adaptive Lighting Sleep Mode at Morning";
        trigger = {
          trigger = "time";
          at = "6:30:00";
        };
        action = [
          {
            service = "switch.turn_off";
            target.entity_id = [
              "switch.adaptive_lighting_sleep_mode_bathroom"
            ];
          }
        ];
      }
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
