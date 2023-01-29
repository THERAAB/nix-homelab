{ config, pkgs, ... }:
let
  triggered-entities-name = "{{ trigger.to_state.attributes.friendly_name }}";
  devices = (import ./devices.properties.nix);
in
{
  services.home-assistant.config = {
    automation = [
      {
        alias = "Water Alarm Alerts";
        trigger = {
          platform = "state";
          entity_id = "${devices.entity-id.basement.water-alarms.hot-water-heater}, ${devices.entity-id.basement.water-alarms.bathroom}, ${devices.entity-id.basement.water-alarms.sewer-trap}";
          from = "off";
          to = "on";
        };
        action = [
          {
            service = "notify.notify";
            data_template.message = "Water Detected! ${triggered-entities-name} is wet!";
          }
          {
            service = "notify.pushbullet";
            data = {
              message = "${triggered-entities-name} is wet!";
              title = "Water Detected!";
            };
          }
        ];
      }
    ];
  };
}