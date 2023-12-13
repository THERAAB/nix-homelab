{...}: let
  port = 8238;
  network = import ../../../share/network.properties.nix;
in {
  services.caddy.virtualHosts."gotify.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  services.gotify = {
    enable = true;
    port = port;
  };
}
