{config, ...}: {
  networking.hostName = "micro-tailscale";
  microvm = {
    interfaces = [
      {
        type = "macvtap";
        macvtap = {
          mode = "bridge";
          link = "enp3s0";
        };
        id = config.networking.hostName;
        mac = "02:00:00:00:00:04";
      }
    ];
  };
  services.tailscale.enable = true;
}
