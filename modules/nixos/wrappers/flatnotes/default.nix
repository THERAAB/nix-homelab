{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.flatnotes;
  gid = 7763;
  port = properties.ports.flatnotes;
  app-name = "flatnotes";
  local-config-dir = "/var/lib/${app-name}";
in {
  options.nix-homelab.wrappers.flatnotes = with types; {
    enable = mkEnableOption (lib.mdDoc "Flatnotes");
  };
  config = mkIf cfg.enable {
    users = {
      users."${app-name}" = {
        uid = properties.users.flatnotes.uid;
        group = app-name;
        isSystemUser = true;
      };
      groups.${app-name}.gid = gid;
    };
    systemd.tmpfiles.rules = [
      "d    ${local-config-dir}     -       -             -   -   - "
      "Z    ${local-config-dir}     -       ${app-name}   -   -   - "
    ];
    virtualisation.oci-containers.containers."${app-name}" = {
      autoStart = true;
      image = "docker.io/dullage/${app-name}";
      volumes = [
        "${local-config-dir}:/data"
      ];
      ports = [
        "${toString port}:8080"
      ];
      environment = {
        PUID = "${toString properties.users.flatnotes.uid}";
        PGID = "${toString gid}";
        UMASK = "022";
        TZ = "America/New_York";
        FLATNOTES_AUTH_TYPE = "none";
      };
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ];
    };
  };
}
