{
  entity-id = {
    basement = {
      water-alarms = {
        hot-water-heater = "binary_sensor.hot_water_heater_water_alarm_moisture";
        bathroom = "binary_sensor.basement_bathroom_water_alarm_moisture";
        sewer-trap = "binary_sensor.sewer_trap_water_alarm_moisture";
      };
      washing-machine.power = "sensor.washing_machine_switch_power";
      dryer.power = "sensor.dryer_switch_power";
    };
    bathroom = {
      humidity = "sensor.bathroom_humidity_sensor_humidity";
      lights = "light.nabu_casa_ha_connect_zbt_1_bathroom_lights";
      motion = "binary_sensor.bathroom_motion_sensor_motion";
    };
    kitchen = {
      cabinet.light = "light.kitchen_over_cabinet_lights";
      motion = "binary_sensor.kitchen_motion_sensor_motion";
      illuminence = "sensor.kitchen_motion_sensor_illuminance";
    };
    phones = {
      pixel = {
        battery = "sensor.pixel_6_battery_level";
        location = "device_tracker.pixel_6";
        notify = "notify.mobile_app_pixel_6";
      };
      galaxy-tab-s7.battery = "sensor.sm_t870_battery_level";
      stephanie = {
        iphone.battery = "sensor.stephanies_phone_battery_level";
        watch.battery = "sensor.stephanies_phone_watch_battery";
      };
    };
    living-room = {
      android-tv = "media_player.android_tv_192_168_127_5";
      lamp = "switch.living_room_lamp_switch";
      govee-immersion = "light.h6199_2328";
    };
  };
  living-room = {
    lamp-sunset-offset = "-0:30:00";
    lamp-off-time = "23:00:00";
  };
}
