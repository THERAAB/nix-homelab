{...}: let
  port = 3000;
  settings = (import ./settings.nix).settings;
  app-name = "adguard";
  network = import ../../../../share/network.properties.nix;
in {
  services = {
    caddy.virtualHosts."${app-name}.${network.domain}" = {
      useACMEHost = "${network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
    adguardhome = {
      mutableSettings = false;
      enable = true;
      settings = settings;
    };
  };
  networking.firewall.allowedTCPPorts = [port];
}
