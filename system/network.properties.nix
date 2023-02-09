{
  nix-homelab = {
    tailscale.ip = "100.121.108.123";
    local.ip = "192.168.3.11";
    subnet = "192.168.3.0/24";
  };
  desktop = {
    subnet = "192.168.2.0/24";
  };
  pfSense.local.ip = "192.168.1.1";
  tplink.local.ip = "192.168.1.102";
  govee-water-alarm.local.ip = "192.168.1.3";
  ring-doorbell.local.ip = "192.168.1.108";
  domain.local = "box";
  domain.tail = "tail";
}