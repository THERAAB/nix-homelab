{...}: let
  devices = import ./devices.properties.nix;
in {
  services.home-assistant.config.automation = [
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
            service = "light.turn_on";
            data = {
              brightness_pct = 25;
              color_temp = "400";
            };
            target.entity_id = [
              devices.entity-id.bathroom.lights
            ];
          };
          "else" = {
            service = "light.turn_on";
            data = {
              brightness_pct = 100;
              color_temp = "100";
            };
            target.entity_id = [
              devices.entity-id.bathroom.lights
            ];
          };
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
}
