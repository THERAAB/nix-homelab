{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.audiobookrequest;
  uid = 9826;
  port = properties.ports.audiobookrequest;
  app-name = "audiobookrequest";
  local-config-dir = "/var/lib/${app-name}";
in {
  options.nix-homelab.wrappers.audiobookrequest = with types; {
    enable = mkEnableOption (lib.mdDoc "Audiobookrequest");
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
      "d    ${local-config-dir}           -       -             -                               -   - "
      "d    ${local-config-dir}/config    -       -             -                               -   - "
      "Z    ${local-config-dir}           -       ${app-name}   ${properties.media.group.name}  -   - "
    ];
    virtualisation.oci-containers.containers."${app-name}" = {
      autoStart = true;
      image = "docker.io/markbeep/${app-name}:latest";
      volumes = [
        "${local-config-dir}/config:/config"
        # "${properties.media.dir.audiobooks}:/audiobooks"
        # "${properties.media.dir.podcasts}:/podcasts"
      ];
      ports = ["${toString port}:8000"];
      environment = {
        UMASK = "022";
        TZ = "America/New_York";
        ABR_APP__OPENAPI_ENABLED = "true";
      };
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ];
    };
  };
}
