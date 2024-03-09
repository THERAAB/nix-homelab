{config, ...}: {
  networking.hostName = "micro-infra";
  microvm = {
    mem = 4096;
    interfaces = [
      {
        type = "macvtap";
        macvtap = {
          mode = "bridge";
          link = "enp3s0";
        };
        id = config.networking.hostName;
        mac = "02:00:00:00:00:03";
      }
    ];
  };
}
