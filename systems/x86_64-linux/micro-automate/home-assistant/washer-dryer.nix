{...}: let
  devices = import ./devices.properties.nix;
in {
  services.home-assistant.config.automation = [
    {
      alias = "Washing Machine Done Notification";
      trigger = {
        platform = "numeric_state";
        entity_id = devices.entity-id.washing-machine.power;
        for = {
          seconds = 90;
        };
        below = 3;
      };
      action = [
        {
          service = "notify.notify";
          data_template.message = "Washing Machine Done";
        }
      ];
    }
    {
      alias = "Dryer Done Notification";
      trigger = {
        platform = "numeric_state";
        entity_id = devices.entity-id.dryer.power;
        for = {
          seconds = 10;
        };
        below = 50;
      };
      action = [
        {
          service = "notify.notify";
          data_template.message = "Dryer Done";
        }
      ];
    }
  ];
}
