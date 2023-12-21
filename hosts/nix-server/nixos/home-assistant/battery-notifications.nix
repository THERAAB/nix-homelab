{...}: let
  devices = import ./devices.properties.nix;
  check-time = "8:30:00";
  battery-threshold = 30;
in {
  services.home-assistant.config = {
    automation = [
      {
        alias = "Low battery alerts";
        use_blueprint = {
          path = "custom/low-battery.yaml";
          input = {
            threshold = battery-threshold;
            time = check-time;
            actions = [
              {
                service = "notify.pushbullet";
                data = {
                  message = "{{sensors}} Low Battery!";
                  title = "The battery of the sensor(s) {{sensors}} is low.";
                };
              }
              {
                service = "notify.gotify";
                data = {
                  message = "{{sensors}} Low Battery!";
                  title = "The battery of the sensor(s) {{sensors}} is low.";
                };
              }
              {
                service = "notify.notify";
                data_template.message = "{{sensors}} Low Battery!";
              }
            ];
            exclude = {
              entity_id = [
                devices.entity-id.phones.pixel.battery
                devices.entity-id.phones.galaxy-tab-s7.battery
              ];
            };
          };
        };
      }
    ];
  };
}
