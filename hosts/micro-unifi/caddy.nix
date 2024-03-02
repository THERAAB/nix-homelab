{...}: let
  network = import ../../share/network.properties.nix;
in {
  imports = [
    ../../share/optional/acme.nix
  ];
  services.caddy = {
    enable = true;
    virtualHosts = {
      #TODO: move to micro-server
      "unifi.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-unifi.local.ip}:8443 {
            transport http {
              tls_insecure_skip_verify
            }
          }
        '';
      };
    };
  };
}
