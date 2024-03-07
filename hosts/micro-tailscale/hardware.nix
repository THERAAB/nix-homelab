{config, ...}: {
  networking.hostName = "micro-tailscale";
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
        mac = "02:00:00:00:00:04";
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
