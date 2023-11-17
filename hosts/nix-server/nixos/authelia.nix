{config, ...}: let
  app-name = "authelia-pumpkin-rodeo";
  local-config-dir = "/var/lib" + "/${app-name}";
  port = 9091;
  network = import ../../../share/network.properties.nix;
in {
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}                     -       -             -               -   - "
    "f    ${local-config-dir}/db.sqlite3          -       -             -               -   - "
    # "f    ${local-config-dir}/users_database.yml  -       -             -               -   - "
    "f    ${local-config-dir}/notification.txt    -       -             -               -   - "
    "Z    ${local-config-dir}                     740     ${app-name}   ${app-name}     -   - "
  ];
  networking.firewall.allowedTCPPorts = [port];
  services.caddy.virtualHosts."auth.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  services.authelia.instances.pumpkin-rodeo = {
    enable = true;
    secrets.storageEncryptionKeyFile = config.sops.secrets.authelia_storage_secret.path;
    secrets.jwtSecretFile = config.sops.secrets.authelia_jwt_secret.path;
    settings = {
      theme = "dark";
      default_redirection_url = "https://pumpkin.rodeo";
      default_2fa_method = "totp";
      log.level = "debug";
      server.disable_healthcheck = true;
      authentication_backend.file.path = "${local-config-dir}/users_database.yml";
      session = {
        name = "authelia_pumpkin_rodeo";
        expiration = "12h";
        inactivity = "45m";
        remember_me_duration = "1M";
        domain = "pumpkin.rodeo";
      };
      regulation = {
        max_retries = 3;
        find_time = "5m";
        ban_time = "15m";
      };
      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = ["auth.pumpkin.rodeo"];
            policy = "bypass";
          }
          {
            domain = ["jellyfin.pumpkin.rodeo"];
            policy = "one_factor";
          }
        ];
      };
      storage = {
        local = {
          path = "${local-config-dir}/db.sqlite3";
        };
      };
      notifier = {
        filesystem = {
          filename = "${local-config-dir}/notification.txt";
        };
      };
    };
  };
}
