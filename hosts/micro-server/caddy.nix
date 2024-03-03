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
      "gotify.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-server.local.ip}:8238
        '';
      };
    };
  };
}
