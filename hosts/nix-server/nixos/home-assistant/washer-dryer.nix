{...}: {
  services.home-assistant.config.automation = [
    {
      alias = "Washing Machine Done Notification";
      trigger = {
        platform = "numeric_state";
        entity_id = "sensor.washing_machine_plug_active_power";
        for = {
          seconds = 90;
        };
      };
      action = [
        {
          service = "notify.pushbullet";
          data = {
            message = "Washing Machine Done";
            title = "Washing Machine Cycle finished";
          };
        }
        {
          service = "notify.notify";
          data_template.message = "Washing Machine Done";
        }
      ];
    }
  ];
}