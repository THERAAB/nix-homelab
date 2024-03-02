{...}: {
  networking = {
    hostName = "micro-unifi";
    firewall = {
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [53];
    };
  };
}
