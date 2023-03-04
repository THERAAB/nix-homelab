{
  nix-server = {
    tailscale.ip = "100.121.108.123";
    local.ip = "192.168.0.2";
    mac = "d8:5e:d3:96:1c:ac";
  };
  desktop = {
    subnet = "192.168.0.0/24";
    local.ip = "10.10.12.2";
    mac = "a8:a1:59:e8:a2:66";
  };
  nix-router = {
    local.ip = "192.168.0.7";
    mac = "00:e2:69:5d:b0:f8";
  };
  tplink = {
    local.ip = "192.168.0.1";
    mac = "00:5f:67:ec:72:c0";
  };
  govee-water-alarm = {
    local.ip = "192.168.0.4";
    mac = "58:bf:25:cd:9a:8b";
  };
  ring-doorbell = {
    local.ip = "192.168.0.3";
    mac = "08:3a:88:32:4b:d4";
  };
  kasa-living-room-plug = {
    local.ip = "192.168.0.6";
    mac = "00:5f:67:81:e0:55";
  };
  android-tv = {
    local.ip = "192.168.0.5";
    mac = "80:cb:bc:34:28:4e";
  };
  domain.local = "box";
  domain.tail = "tail";
  lan-interfaces = [ "enp2s0" "eno1" "enp4s0" ];
  lan1-address = "10.10.11.1";
  lan2-address = "10.10.12.1";
  lan3-address = "10.10.13.1";
  wan-interface = "enp1s0";
  prefixLength = 24;
  localhost = "127.0.0.1";
}
