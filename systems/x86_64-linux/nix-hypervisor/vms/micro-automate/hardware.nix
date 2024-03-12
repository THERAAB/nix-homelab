{config, ...}: {
  networking.hostName = "micro-automate";
  microvm = {
    interfaces = [
      {
        type = "macvtap";
        macvtap = {
          mode = "bridge";
          link = "enp3s0";
        };
        id = config.networking.hostName;
        mac = "02:00:00:00:00:06";
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
