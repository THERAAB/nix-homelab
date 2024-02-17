{config, ...}: let
  port = 9080;
  app-name = "microbin";
  network = import ../../../share/network.properties.nix;
in {
  networking.firewall.allowedTCPPorts = [port];
  services = {
    caddy.virtualHosts."${app-name}.${network.domain}" = {
      useACMEHost = "${network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
    microbin = {
      enable = true;
      passwordFile = config.sops.secrets.df_password.path;
      settings = {
        MICROBIN_PORT = port;
      };
    };
  };
}
