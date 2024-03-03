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
      "vuetorrent.${network.domain}" = {
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-media.local.ip}:8112
        '';
      };
    };
  };
}
