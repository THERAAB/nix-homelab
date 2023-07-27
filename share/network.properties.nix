{
  nix-server = {
    tailscale.ip = "100.121.108.123";
    local.ip = "192.168.3.2";
  };
  desktop.subnet = "192.168.2.0/24";
  pfSense.local.ip = "192.168.1.1";
  unifi-ap-6-plus.local.ip = "192.168.1.52";
  unifi-usw-lite.local.ip = "192.168.1.51";
  govee-water-alarm.local.ip = "192.168.1.3";
  ring-doorbell.local.ip = "192.168.1.4";
  kasa-living-room-plug.local.ip = "192.168.1.6";
  android-tv.local.ip = "192.168.1.5";
  domain.local = "box";
  domain.tail = "tail";
}
