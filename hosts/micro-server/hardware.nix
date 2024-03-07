{config, ...}: {
  networking.hostName = "micro-server";
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
        mac = "02:00:00:00:00:02";
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        source = "/sync";
        mountPoint = "/sync"; #TODO: fix share
        tag = "sync";
      }
    ];
  };
  services.tailscale.enable = true; # TODO: remove
}
