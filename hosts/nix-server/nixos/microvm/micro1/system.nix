{config, ...}: {
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
        tag = "secrets";
      }
      {
        source = "/var/lib/microvms/${config.networking.hostName}/journal";
        mountPoint = "/var/log/journal";
        tag = "journal";
        proto = "virtiofs";
        socket = "journal.sock";
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
  environment.etc."machine-id" = {
    mode = "0644";
    text = "2bac078a34d34a28bf782462b102720a\n"; # 
  };
  #services.tailscale = {
  #  enable = true;
  #  extraUpFlags = ["--ssh"];
  #  authKeyFile = "";
  #};
}
