{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.beszel-hub;
  port = properties.ports.beszel;
in {
  options.nix-homelab.wrappers.beszel-hub = with types; {
    enable = mkEnableOption (lib.mdDoc "Beszel hub");
  };
  config = mkIf cfg.enable {
    services.caddy.virtualHosts = {
      "beszel.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-hypervisor.local.ip}:${toString properties.ports.beszel}
        '';
      };
    };
    services.beszel.hub = {
      enable = true;
      port = port;
      host = "0.0.0.0";
    };
  };
}
