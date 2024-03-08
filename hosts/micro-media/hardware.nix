{config, ...}: {
  networking.hostName = "micro-media";
  microvm = {
    mem = 6144;
    interfaces = [
      {
        type = "macvtap";
        macvtap = {
          mode = "bridge";
          link = "enp3s0";
        };
        id = config.networking.hostName;
        mac = "02:00:00:00:00:01";
      }
    ];
  };
  services.tailscale.enable = true; # TODO: remove, merge journal
}
