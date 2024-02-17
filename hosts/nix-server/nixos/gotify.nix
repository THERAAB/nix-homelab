{...}: let
  port = 8238;
  app-name = "gotify";
  network = import ../../../share/network.properties.nix;
in {
  services = {
    caddy.virtualHosts."${app-name}.${network.domain}" = {
      useACMEHost = "${network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
    ${app-name} = {
      enable = true;
      port = port;
    };
  };
}
