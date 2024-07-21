{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.tdarr;
  uid = 9981;
  port = properties.ports.tdarr;
  app-name = "tdarr";
  local-config-dir = "/var/lib/${app-name}";
in {
  options.nix-homelab.wrappers.tdarr = with types; {
    enable = mkEnableOption (lib.mdDoc "Tdarr");
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
      image = "ghcr.io/haveagitgat/${app-name}";
      volumes = [
        "${local-config-dir}:/app/configs"
        "${properties.media.dir.tv}:/tv"
        "${properties.media.dir.movies}:/movies"
      ];
      ports = ["${toString port}:8265"];
      environment = {
        PUID = "${toString uid}";
        PGID = "${toString properties.media.group.id}";
        UMASK = "022";
        TZ = "America/New_York";
        serverIP = "0.0.0.0";
        webUIPort = "${toString port}";
      };
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
        "--device=/dev/dri/renderD128:/dev/dri/renderD128"
        "--device=/dev/dri/card0:/dev/dri/card0"
        "--gpus=all"
      ];
    };
  };
}
