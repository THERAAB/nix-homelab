{...}: let
  network = import ../../share/network.properties.nix;
in {
  services.caddy = {
    enable = true;
    virtualHosts = {
      #TODO: move to micro-server
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
