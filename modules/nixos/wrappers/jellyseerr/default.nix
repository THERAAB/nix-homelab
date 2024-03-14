{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.jellyseerr;
  uid = 9991;
  port = properties.ports.jellyseerr;
  app-name = "jellyseerr";
  local-config-dir = "/var/lib/${app-name}";
in {
  options.nix-homelab.wrappers.jellyseerr = with types; {
    enable = mkEnableOption (lib.mdDoc "Jellyseerr");
  };
  config = mkIf cfg.enable {
    users = {
      users."${app-name}" = {
        uid = uid;
        group = properties.media.group.name;
        isSystemUser = true;
      };
    };
    systemd.tmpfiles.rules = [
      "d    ${local-config-dir}     -       -           -                                 -   - "
      "Z    ${local-config-dir}     -       ${app-name} ${properties.media.group.name}    -   - "
    ];
    virtualisation.oci-containers.containers."${app-name}" = {
      autoStart = true;
      image = "docker.io/fallenbagel/${app-name}";
      volumes = [
        "${local-config-dir}:/app/config"
        "${properties.media.dir.movies}:/movies"
        "${properties.media.dir.tv}:/tv"
      ];
      ports = ["${toString port}:5055"];
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
