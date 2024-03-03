{...}: let
  network = import ../../share/network.properties.nix;
in {
  imports = [
    ../../share/optional/acme.nix
  ];
  networking.firewall.allowedTCPPorts = [80 443];
  services.caddy = {
    enable = true;
    virtualHosts = {
      #TODO: move to micro-server
      "unifi.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-networking.local.ip}:8443 {
            transport http {
              tls_insecure_skip_verify
            }
          }
        '';
      };
    };
  };
}
