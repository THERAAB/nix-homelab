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
  services = {
    openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    tailscale = {
      enable = true;
      extraUpFlags = ["--ssh"];
    };
  };
}
