{config, ...}: {
  microvm = {
    mem = 8192;
    interfaces = [
      {
        type = "macvtap";
        macvtap = {
          mode = "bridge";
          link = "enp3s0";
        };
        id = config.networking.hostName;
        mac = "02:00:00:00:00:02";
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        source = "/sync";
        mountPoint = "/sync";
        tag = "sync";
      }
    ];
  };
}
