{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.services.filebrowser;
  uid = 7642;
  gid = 7643;
  port = properties.ports.filebrowser;
  app-name = "filebrowser";
  local-config-dir = "/var/lib/${app-name}";
  dir-to-share = "/sync";
in {
  options.nix-homelab.services.filebrowser = with types; {
    enable = mkEnableOption (lib.mdDoc "System");
  };
  config = mkIf cfg.enable {
    users = {
      users."${app-name}" = {
        uid = uid;
        group = app-name;
        isSystemUser = true;
        extraGroups = ["syncthing" "photoprism" "flatnotes"];
      };
      groups.${app-name}.gid = gid;
    };
    systemd.tmpfiles.rules = [
      "d    ${dir-to-share}                 -       -             -           -   - "
      "d    ${local-config-dir}             -       -             -           -   - "
      "f    ${local-config-dir}/database.db -       -             -           -   - "
      "Z    ${local-config-dir}             -       ${app-name}   ${app-name} -   - "
    ];
    virtualisation.oci-containers.containers."${app-name}" = {
      autoStart = true;
      image = "docker.io/${app-name}/${app-name}";
      volumes = [
        "${dir-to-share}:/srv"
        "${local-config-dir}/database.db:/database.db"
      ];
      ports = [
        "${toString port}:80"
      ];
      environment = {
        PUID = "${toString uid}";
        PGID = "${toString gid}";
        UMASK = "022";
        TZ = "America/New_York";
      };
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ];
    };
  };
}
