{...}: let
  port = 19999;
  app-name = "netdata";
  network = import ../../share/network.properties.nix;
in {
  services = {
    caddy.virtualHosts."${app-name}.${network.domain}" = {
      useACMEHost = "${network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
    netdata.config.registry.enabled = "yes";
  };
}
