{...}: {
  networking = {
    hostName = "micro-server";
    firewall = {
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [53];
    };
  };
}
