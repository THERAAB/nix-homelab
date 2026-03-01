{config, ...}: {
  networking.hostName = "micro-download";
  microvm = {
    interfaces = [
      {
        type = "macvtap";
        macvtap = {
          mode = "bridge";
          link = "enp3s0";
        };
        id = config.networking.hostName;
        mac = "02:00:00:00:00:05";
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        source = "/run/secrets/${config.networking.hostName}";
        mountPoint = "/run/secrets";
        tag = "secrets";
      }
    ];
  };
}
