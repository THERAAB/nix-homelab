{config, ...}: let
  network = import ../../../share/network.properties.nix;
  port = 5000;
in {
  services.harmonia = {
    enable = true;
    signKeyPath = config.sops.secrets.harmonia-key.path;
  };
  nix.settings.allowed-users = ["harmonia"];
  services.caddy.virtualHosts."cache.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
