{...}: {
  microvm = {
    interfaces = [
      {
        type = "macvtap";
        macvtap = {
          mode = "bridge";
          link = "enp3s0";
        };
        id = "micro1";
        mac = "02:00:00:00:00:01";
      }
    ];
    devices = [
      #{
      #  bus = "pci";
      #  path = "0000:00:02.0";
      #}
      {
        bus = "usb";
        path = "vendorid=0x1a86,productid=0x55d4";
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        source = "/run/secrets";
        mountPoint = "/run/secrets";
      }
    ];
  };
  networking = {
    hostName = "micro1";
    firewall = {
      #  trustedInterfaces = ["tailscale0"];
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [53];
    };
  };
  #services.tailscale = {
  #  enable = true;
  #  extraUpFlags = ["--ssh"];
  #  authKeyFile = "";
  #};
}
