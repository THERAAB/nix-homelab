{
  nix-server = {
    tailscale.ip = "100.121.108.123";
    local.ip = "192.168.3.2";
  };
  desktop.subnet = "192.168.2.0/24";
  pfSense.local.ip = "192.168.1.1";
  tplink.local.ip = "192.168.1.2";
  govee-water-alarm.local.ip = "192.168.1.4";
  ring-doorbell.local.ip = "192.168.1.3";
  kasa-living-room-plug.local.ip = "192.168.1.6";
  android-tv.local.ip = "192.168.1.5";
  domain.local = "box";
  domain.tail = "tail";
}