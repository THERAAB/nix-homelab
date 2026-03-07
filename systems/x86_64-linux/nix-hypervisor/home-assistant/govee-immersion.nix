{...}: let
  devices = import ./devices.properties.nix;
in {
  nix-homelab.wrappers.govee2mqtt.enable = true;
  services.home-assistant.config.automation = [
    {
      alias = "Turn on Govee with TV";
      trigger = {
        platform = "state";
        entity_id = devices.entity-id.living-room.android-tv;
        from = "off";
        to = "idle";
      };
      action = {
        service = "light.turn_on";
        target = {
          entity_id = devices.entity-id.living-room.govee-immersion;
        };
      };
    }
    {
      alias = "Turn off Govee with TV";
      trigger = {
        platform = "state";
        entity_id = devices.entity-id.living-room.android-tv;
        from = "idle";
        to = "off";
      };
      action = {
        service = "light.turn_off";
        target = {
          entity_id = devices.entity-id.living-room.govee-immersion;
        };
      };
    }
  ];
}
