{...}: let
  hostname = "micro-server";
in {
  networking = {
    hostName = "${hostname}";
    firewall = {
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [53];
    };
  };
}
