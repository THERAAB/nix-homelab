{...}: {
  services.home-assistant.config.automation = [
    {
      alias = "Turn on dim Kitchen lights when motion detected at night";
      trigger = {
        platform = "state";
        entity_id = "binary_sensor.lumi_lumi_motion_ac02_motion_2";
        from = "off";
        to = "on";
      };
      condition = {
        condition = "sun";
        after = "sunset";
      };
      action = [
        {
          service = "light.turn_on";
          data = {
            brightness_pct = 15;
            color_temp = "400";
          };
          target.entity_id = [
            "light.wiz_tunable_white_df9586"
            "light.wiz_tunable_white_1ade1e"
          ];
        }
        {
          wait_for_trigger = {
            platform = "state";
            entity_id = "binary_sensor.lumi_lumi_motion_ac02_motion_2";
            from = "on";
            to = "off";
            for = {
              hours = 0;
              minutes = 5;
              seconds = 0;
            };
          };
        }
        {
          service = "light.turn_off";
          target.entity_id = [
            "light.wiz_tunable_white_df9586"
            "light.wiz_tunable_white_1ade1e"
          ];
        }
      ];
    }
  ];
}
