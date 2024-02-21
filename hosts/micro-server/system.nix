{...}: {
  microvm = {
    hypervisor = "cloud-hypervisor";
    kernelParams = ["i915.force_probe=4692"];
    interfaces = [
      {
        type = "macvtap";
        macvtap = {
          mode = "bridge";
          link = "enp3s0";
        };
        id = "micro-server";
        mac = "02:00:00:00:00:02";
      }
    ];
    #shares = [
    #  {
    #    proto = "virtiofs";
    #    source = "/run/secrets";
    #    mountPoint = "/run/secrets";
    #    tag = "secrets";
    #  }
    #  {
    #    proto = "virtiofs";
    #    source = "/var/lib/microvms/micro-server/storage/etc/ssh";
    #    mountPoint = "/etc/ssh";
    #    tag = "ssh";
    #  }
    #  {
    #    proto = "virtiofs";
    #    source = "/var/lib/microvms/micro-server/storage/var/lib";
    #    mountPoint = "/var/lib";
    #    tag = "var-lib";
    #  }
    #];
  };
  #fileSystems = {
  #  "/etc/ssh".neededForBoot = true;
  #  "/var/lib".neededForBoot = true;
  #};
  networking = {
    hostName = "micro-server";
    firewall = {
      #trustedInterfaces = ["tailscale0"];
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [53];
    };
    #networkmanager.enable = true;
  };
  #environment.noXlibs = false;
  #services.tailscale = {
  #  enable = true;
  #  extraUpFlags = ["--ssh"];
  #};
}
