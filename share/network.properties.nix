{
  nix-server = {
    tailscale.ip = "100.121.108.123";
    local.ip = "192.168.3.2";
  };
  desktop.subnet = "192.168.2.0/24";
  pfSense.local.ip = "192.168.1.1";
  unifi-u6-plus.local.ip = "192.168.1.2";
  unifi-usw-lite-8.local.ip = "192.168.1.3";
  govee-water-alarm.local.ip = "192.168.127.3";
  ring-doorbell.local.ip = "192.168.127.4";
  kasa-living-room-plug.local.ip = "192.168.127.6";
  android-tv.local.ip = "192.168.127.5";
  domain.local = "box";
  domain.tail = "tail";
}
