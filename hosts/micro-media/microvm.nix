{...}: let
  hostname = "micro-media";
in {
  microvm = {
    mem = 8192;
    interfaces = [
      {
        type = "macvtap";
        macvtap = {
          mode = "bridge";
          link = "enp3s0";
        };
        id = hostname;
        mac = "02:00:00:00:00:01";
      }
    ];
    devices = [
      {
        bus = "pci";
        path = "0000:00:02.0";
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        source = "/run/secrets";
        mountPoint = "/run/secrets";
        tag = "secrets";
      }
      {
        proto = "virtiofs";
        source = "/var/lib/microvms/${hostname}/storage/etc/ssh";
        mountPoint = "/etc/ssh";
        tag = "ssh";
      }
      {
        proto = "virtiofs";
        source = "/var/lib/microvms/${hostname}/storage/var/lib";
        mountPoint = "/var/lib";
        tag = "var-lib";
      }
    ];
  };
}
