{pkgs, ...}: let
  devices = import ./devices.properties.nix;
in {
  services.home-assistant = {
    customComponents = [
      pkgs.nix-homelab.home-assistant-hubspace
    ];
    config = {
      adaptive_lighting = [
        {
          name = "bedroom";
          lights = [
            devices.entity-id.bedroom.spinny-boi.light
          ];
          transition = 0;
          initial_transition = 0;
          min_brightness = 10;
          max_brightness = 100;
          min_color_temp = 2700;
          max_color_temp = 4000;
          sleep_brightness = 1;
          sleep_color_temp = 2700;
          sunrise_offset = 1800;
          sunset_offset = 1800; # 30min
        }
      ];
      automation = [
        {
          alias = "Switch On Bedroom Adaptive Lighting Sleep Mode at Night";
          trigger = {
            trigger = "time";
            at = "21:30:00";
          };
          action = [
            {
              service = "switch.turn_on";
              target.entity_id = [
                "switch.adaptive_lighting_sleep_mode_bedroom"
              ];
            }
          ];
        }
        {
          alias = "Switch Off Bedroom Adaptive Lighting Sleep Mode at Morning";
          trigger = {
            trigger = "time";
            at = "6:30:00";
          };
          action = [
            {
              service = "switch.turn_off";
              target.entity_id = [
                "switch.adaptive_lighting_sleep_mode_bedroom"
              ];
            }
          ];
        }
        {
          alias = "Switch Off Bedroom Fan at Morning";
          trigger = {
            trigger = "time";
            at = "6:30:00";
          };
          action = [
            {
              action = "fan.turn_off";
              target.entity_id =
                devices.entity-id.bedroom.spinny-boi.fan;
            }
          ];
        }
        {
          alias = "Switch On Bedroom Fan at Night";
          trigger = {
            trigger = "time";
            at = "20:30:00";
          };
          action = [
            {
              action = "fan.set_percentage";
              target.entity_id =
                devices.entity-id.bedroom.spinny-boi.fan;
              data.percentage = 10;
            }
            {
              action = "fan.turn_on";
              target.entity_id =
                devices.entity-id.bedroom.spinny-boi.fan;
            }
          ];
        }
      ];
    };
  };
}
