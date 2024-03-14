{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.services.linkding;
  uid = 7662;
  gid = 7663;
  port = properties.ports.linkding;
  app-name = "linkding";
  local-config-dir = "/var/lib/${app-name}";
in {
  options.nix-homelab.services.linkding = with types; {
    enable = mkEnableOption (lib.mdDoc "System");
  };
  config = mkIf cfg.enable {
    users = {
      users."${app-name}" = {
        uid = uid;
        group = app-name;
        isSystemUser = true;
      };
      groups.${app-name}.gid = gid;
    };
    systemd.tmpfiles.rules = [
      "d    ${local-config-dir}     -       -             -           -   - "
      "Z    ${local-config-dir}     -       ${app-name}   ${app-name} -   - "
    ];
    virtualisation.oci-containers.containers."${app-name}" = {
      autoStart = true;
      image = "docker.io/sissbruecker/${app-name}";
      volumes = [
        "${local-config-dir}:/etc/linkding/data"
      ];
      ports = [
        "${toString port}:9090"
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
