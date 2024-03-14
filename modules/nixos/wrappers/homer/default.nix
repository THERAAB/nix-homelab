{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.homer;
  gid = 4444;
  uid = 4444;
  port = properties.ports.homer;
  app-name = "homer";
  mount-icons-dir = "/icons";
  local-config-dir = "/var/lib/${app-name}";
  conf = import ./config.nix;
  environment = {
    UMASK = "022";
    INIT_ASSETS = "0";
    TZ = "America/New_York";
  };
in {
  options.nix-homelab.wrappers.homer = with types; {
    enable = mkEnableOption (lib.mdDoc "System");
  };
  config = mkIf cfg.enable {
    nix-homelab.services.yamlConfigMaker."${app-name}" = {
      path = "${local-config-dir}/config.yml";
      settings = conf;
    };
    systemd.tmpfiles.rules = [
      "d    ${local-config-dir}            -   -               -               -   -                     "
      "R    ${local-config-dir}/icons      -   -               -               -   -                     "
      "C    ${local-config-dir}/icons      -   -               -               -   ${mount-icons-dir}    "
      "Z    ${local-config-dir}            -   ${app-name}     ${app-name}     -   -                     "
    ];
    users = {
      groups.${app-name}.gid = gid;
      users.${app-name} = {
        group = app-name;
        uid = uid;
        isSystemUser = true;
      };
    };
    virtualisation.oci-containers.containers."${app-name}" = {
      autoStart = true;
      image = "docker.io/b4bz/${app-name}";
      volumes = [
        "${local-config-dir}:/www/assets"
      ];
      ports = ["${toString port}:8080"];
      user = "${toString uid}";
      environment = environment;
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ];
    };
  };
}
