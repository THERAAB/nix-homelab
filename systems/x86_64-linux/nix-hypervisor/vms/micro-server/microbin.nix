{ports, ...}: let
  port = ports.microbin;
in {
  networking.firewall.allowedTCPPorts = [port];
  services.microbin = {
    enable = true;
    passwordFile = "/run/secrets/df_password";
    settings = {
      MICROBIN_PORT = port;
    };
  };
}
