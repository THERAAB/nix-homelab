{
  entity-id = {
    basement = {
      water-alarms = {
        hot-water-heater = "binary_sensor.lumi_lumi_sensor_wleak_aq1_iaszone_3";
        bathroom = "binary_sensor.lumi_lumi_sensor_wleak_aq1_iaszone_2";
        sewer-trap = "binary_sensor.lumi_lumi_sensor_wleak_aq1_iaszone";
      };
    };
    phones = {
      pixel = {
        battery = "sensor.pixel_6_battery_level";
        location = "device_tracker.pixel_6";
        notify = "notify.mobile_app_pixel_6";
      };
      galaxy-tab-s7.battery = "sensor.sm_t870_battery_level";
    };
    living-room = {
      android-tv = "media_player.android_tv_192_168_127_5";
      lamp = "switch.living_room_lamp";
      govee-immersion = "light.h6199_2328";
    };
  };
  living-room = {
    lamp-sunset-offset = "-0:30:00";
    lamp-off-time = "23:00:00";
  };
}
