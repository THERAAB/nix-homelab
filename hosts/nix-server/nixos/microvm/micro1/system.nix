{...}: {
  microvm.interfaces = [
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
