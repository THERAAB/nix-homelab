{
  lib,
  config,
  pkgs,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.unifi;
  port = properties.ports.unifi;
in {
  options.nix-homelab.wrappers.unifi = with types; {
    enable = mkEnableOption (lib.mdDoc "Unifi");
  };
  config = mkIf cfg.enable {
    services.unifi = {
      enable = true;
      openFirewall = true;
      unifiPackage = pkgs.unifi;
      mongodbPackage = pkgs.mongodb-7_0;
    };
    # Change kill timeout for unifi because it never dies
    systemd.services.unifi.serviceConfig.TimeoutSec = lib.mkForce "1min";
    networking.firewall.allowedTCPPorts = [port];
    services.caddy.virtualHosts = {
      "unifi.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-hypervisor.local.ip}:${toString properties.ports.unifi} {
            header_up Host {host}
            transport http {
              tls_insecure_skip_verify
            }
          }
        '';
      };
    };
  };
}
