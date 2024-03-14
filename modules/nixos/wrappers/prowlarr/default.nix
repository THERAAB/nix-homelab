{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.prowlarr;
  uid = 9993;
  port = properties.ports.prowlarr;
  app-name = "prowlarr";
  local-config-dir = "/var/lib/${app-name}";
in {
  options.nix-homelab.wrappers.prowlarr = with types; {
    enable = mkEnableOption (lib.mdDoc "Prowlarr");
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
      image = "lscr.io/linuxserver/${app-name}:develop";
      volumes = [
        "${local-config-dir}:/config"
      ];
      ports = ["${toString port}:9696"];
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
