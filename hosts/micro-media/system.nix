{...}: let
  hostname = "micro-media";
in {
  networking = {
    hostName = "${hostname}"; #TODO: share
    firewall = {
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [53];
    };
  };
}
