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
    shares = [
      {
        proto = "virtiofs";
        source = "/run/secrets/${config.networking.hostName}";
        mountPoint = "/run/secrets";
        tag = "secrets";
      }
    ];
  };
  services.tailscale.enable = true;
}
