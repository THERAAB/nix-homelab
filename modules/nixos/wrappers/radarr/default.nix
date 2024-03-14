{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.radarr;
  uid = 9994;
  port = properties.ports.radarr;
  app-name = "radarr";
  local-config-dir = "/var/lib/${app-name}";
in {
  options.nix-homelab.wrappers.radarr = with types; {
    enable = mkEnableOption (lib.mdDoc "Radarr");
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
        "${properties.media.dir.movies}:/movies"
        "${properties.media.dir.downloads}:/app/qBittorrent/downloads"
      ];
      ports = ["${toString port}:7878"];
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
