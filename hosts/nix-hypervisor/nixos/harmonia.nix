{config, ...}: let
  network = import ../../../share/network.properties.nix;
  port = 5000;
in {
  services = {
    caddy.virtualHosts."cache.${network.domain}" = {
      useACMEHost = "${network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
    harmonia = {
      enable = true;
      signKeyPath = config.sops.secrets.harmonia_secret.path;
    };
  };
  nix.settings.allowed-users = ["harmonia"];
}
