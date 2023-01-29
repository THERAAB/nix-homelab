{
  entity-id = {
    basement = {
      water-alarms = {
        hot-water-heater = "binary_sensor.lumi_lumi_sensor_wleak_aq1_iaszone_3";
        bathroom = "binary_sensor.lumi_lumi_sensor_wleak_aq1_iaszone_2";
        sewer-trap = "binary_sensor.lumi_lumi_sensor_wleak_aq1_iaszone";
      };
    };
    battery.phones = {
      pixel = "sensor.pixel_6_battery_level";
      galaxy-tab-s7 = "sensor.sm_t870_battery_level";
    };
    living-room = {
      android-tv = "media_player.android_tv_192_168_1_115";
      lamp = "switch.living_room_lamp";
      govee-immersion = "light.h6199_2328";
    };
  };
  living-room = {
    lamp-sunset-offset = "-0:30:00";
    lamp-off-time = "23:00:00";
  };
}