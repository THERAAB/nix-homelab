{...}: {
  services.home-assistant.config.automation = [
    {
      alias = "Turn on Bathroom lights when motion detected";
      trigger = {
        platform = "state";
        entity_id = "binary_sensor.lumi_lumi_motion_ac02_motion_2";
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
              "light.silicon_labs_ezsp_bathroom_lights"
            ];
          };
          "else" = {
            service = "light.turn_on";
            data = {
              brightness_pct = 100;
              color_temp = "100";
            };
            target.entity_id = [
              "light.silicon_labs_ezsp_bathroom_lights"
            ];
          };
        }
        {
          wait_for_trigger = {
            platform = "state";
            entity_id = "binary_sensor.lumi_lumi_motion_ac02_motion_2";
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
              entity_id = "sensor.lumi_lumi_weather_humidity";
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
            "light.silicon_labs_ezsp_bathroom_lights"
          ];
        }
      ];
    }
  ];
}
