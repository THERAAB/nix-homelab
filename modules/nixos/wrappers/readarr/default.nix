{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.readarr;
  uid = 9997;
  port = properties.ports.readarr;
  app-name = "readarr";
  local-config-dir = "/var/lib/${app-name}/";
in {
  options.nix-homelab.wrappers.readarr = with types; {
    enable = mkEnableOption (lib.mdDoc "Readarr");
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
        "${properties.media.dir.audiobooks}:/books"
        "${properties.media.dir.downloads}:/app/qBittorrent/downloads"
      ];
      ports = ["${toString port}:8787"];
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
