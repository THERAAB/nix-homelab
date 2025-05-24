{pkgs, ...}: let
  devices = import ./devices.properties.nix;
in {
  services.home-assistant = {
    customComponents = [
      pkgs.nix-homelab.hacs-govee
    ];
    config.automation = [
      {
        alias = "Turn on Govee with TV after sunset ${devices.living-room.lamp-sunset-offset}";
        trigger = {
          platform = "state";
          entity_id = devices.entity-id.living-room.android-tv;
          from = "off";
          to = "idle";
        };
        condition = {
          condition = "sun";
          after = "sunset";
          after_offset = devices.living-room.lamp-sunset-offset;
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
  };
}
