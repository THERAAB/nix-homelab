{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.flaresolverr;
  uid = 9812;
  port = properties.ports.flaresolverr;
  app-name = "flaresolverr";
in {
  options.nix-homelab.wrappers.flaresolverr = with types; {
    enable = mkEnableOption (lib.mdDoc "Flaresolverr");
  };
  config = mkIf cfg.enable {
    users = {
      users."${app-name}" = {
        uid = uid;
        group = properties.media.group.name;
        isSystemUser = true;
      };
    };
    virtualisation.oci-containers.containers."${app-name}" = {
      autoStart = true;
      image = "ghcr.io/${app-name}/${app-name}";
      ports = ["${toString port}:8191"];
      environment = {
        PUID = "${toString uid}";
        PGID = "${toString properties.media.group.id}";
        UMASK = "022";
        TZ = "America/New_York";
      };
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ];
    };
  };
}
