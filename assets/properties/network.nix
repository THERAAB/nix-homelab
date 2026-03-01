{
  nix-hypervisor = {
    tailscale.ip = "100.121.108.123";
    local.ip = "192.168.3.2";
  };
  micro-automate = {
    local.ip = "192.168.3.8";
    machine-id = "a99ebf2643d6aa1a67dabcc3450ca778";
  };
  micro-infra = {
    local.ip = "192.168.3.5";
    machine-id = "7964eeea619240a9a312ecff2bf3ffe2";
  };
  micro-tailscale = {
    tailscale.ip = "100.103.162.45";
    local.ip = "192.168.3.6";
    machine-id = "58ce21dec8db4860b484cdf1ad45ecb4";
  };
  nix-zenbook = {
    local.ip = "192.168.1.4";
    tailscale.ip = "100.85.214.18";
  };
  nix-desktop = {
    tailscale.ip = "100.126.231.47";
    local.ip = "192.168.1.5";
  };
  nix-nas = {
    tailscale.ip = "100.122.29.88";
    local.ip = "192.168.2.2";
  };
  pfSense.local.ip = "192.168.1.1";
  unifi-u6-plus.local.ip = "192.168.1.2";
  unifi-usw-lite-8.local.ip = "192.168.1.3";
  govee-water-alarm.local.ip = "192.168.127.3";
  ring-doorbell.local.ip = "192.168.127.4";
  android-tv.local.ip = "192.168.127.5";
  b-hyve.local.ip = "192.168.127.7";
  ecobee.local.ip = "192.168.127.8";
  domain = "pumpkin.rodeo";
  ap.subnet = "192.168.1.0/24";
}
