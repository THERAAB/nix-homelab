{...}: let
  gid = 4444;
  uid = 4444;
  port = 8082;
  app-name = "homer";
  system-icons-dir = "/nix/persist/nix-homelab/share/assets/icons";
  local-config-dir = "/var/lib/${app-name}";
  config = import ./config.nix;
  environment = {
    UMASK = "022";
    INIT_ASSETS = "0";
    TZ = "America/New_York";
  };
in {
  microvm.shares = [
    {
      proto = "virtiofs";
      source = system-icons-dir;
      mountPoint = "${local-config-dir}/icons"; #TODO: fix permissions
      tag = "${app-name}-icons";
    }
  ];
  services = {
    yamlConfigMaker."${app-name}" = {
      path = "${local-config-dir}/config.yml";
      settings = config;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}                 -   -               -               -   -                     "
    "Z    ${local-config-dir}                 -   ${app-name}     ${app-name}     -   -                     "
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
}
