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
        tag = "secrets";
      }
      {
        proto = "virtiofs";
        source = "/var/lib/acme";
        mountPoint = "/var/lib/acme";
        tag = "acme";
      }
      {
        proto = "virtiofs";
        source = "/var/lib/microvms/micro1/storage/var/lib/containers";
        mountPoint = "/var/lib/containers";
        tag = "containers";
      }
      {
        proto = "virtiofs";
        source = "/var/lib/microvms/micro1/storage/var/lib/NetworkManager";
        mountPoint = "/var/lib/NetworkManager";
        tag = "networkmanager";
      }
      {
        proto = "virtiofs";
        source = "/var/lib/microvms/micro1/storage/var/lib/tailscale";
        mountPoint = "/var/lib/tailscale";
        tag = "tailscale";
      }
    ];
  };
  networking = {
    hostName = "micro1";
    firewall = {
      trustedInterfaces = ["tailscale0"];
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [53];
    };
    networkmanager.enable = true;
  };
  environment.noXlibs = false;
  services.tailscale = {
    enable = true;
    extraUpFlags = ["--ssh"];
  };
}
