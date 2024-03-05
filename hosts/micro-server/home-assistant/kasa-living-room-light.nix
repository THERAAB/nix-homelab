let
  devices = import ./devices.properties.nix;
in {
  services.home-assistant.config.automation = [
    {
      alias = "Turn lamp off if TV on";
      trigger = {
        platform = "state";
        entity_id = devices.entity-id.living-room.android-tv;
        from = "off";
        to = "idle";
      };
      action = {
        service = "switch.turn_off";
        target = {
          entity_id = "switch.living_room_lamp_switch";
        };
      };
    }
    {
      alias = "Turn lamp on when TV off between sunset ${devices.living-room.lamp-sunset-offset} and ${devices.living-room.lamp-off-time}";
      trigger = {
        platform = "state";
        entity_id = devices.entity-id.living-room.android-tv;
        from = "idle";
        to = "off";
      };
      condition = {
        condition = "and";
        conditions = [
          {
            condition = "sun";
            after = "sunset";
            after_offset = devices.living-room.lamp-sunset-offset;
          }
          {
            condition = "time";
            before = devices.living-room.lamp-off-time;
            weekday = ["mon" "tue" "wed" "thu" "fri" "sat" "sun"];
          }
        ];
      };
      action = {
        service = "switch.turn_on";
        target = {
          entity_id = "switch.living_room_lamp_switch";
        };
      };
    }
    {
      alias = "Turn lamp on at sunset ${devices.living-room.lamp-sunset-offset} if TV off";
      trigger = {
        platform = "sun";
        event = "sunset";
        offset = devices.living-room.lamp-sunset-offset;
      };
      condition = {
        condition = "state";
        state = "off";
        entity_id = devices.entity-id.living-room.android-tv;
      };
      action = {
        service = "switch.turn_on";
        target = {
          entity_id = "switch.living_room_lamp_switch";
        };
      };
    }
    {
      alias = "Turn lamp off after ${devices.living-room.lamp-off-time}";
      trigger = {
        platform = "time";
        at = devices.living-room.lamp-off-time;
      };
      action = {
        service = "switch.turn_off";
        target = {
          entity_id = "switch.living_room_lamp_switch";
        };
      };
    }
  ];
}
