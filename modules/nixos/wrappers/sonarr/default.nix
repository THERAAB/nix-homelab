{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.sonarr;
  uid = 9995;
  port = properties.ports.sonarr;
  app-name = "sonarr";
  local-config-dir = "/var/lib/${app-name}";
in {
  options.nix-homelab.wrappers.sonarr = with types; {
    enable = mkEnableOption (lib.mdDoc "Sonarr");
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
      "d    ${local-config-dir}     -       -             -                              -   - "
      "Z    ${local-config-dir}     -       ${app-name}   ${properties.media.group.name} -   - "
    ];
    virtualisation.oci-containers.containers."${app-name}" = {
      autoStart = true;
      image = "lscr.io/linuxserver/${app-name}";
      volumes = [
        "${local-config-dir}:/config"
        "${properties.media.dir.tv}:/tv"
        "${properties.media.dir.downloads}:/app/qBittorrent/downloads"
      ];
      ports = ["${toString port}:8989"];
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
