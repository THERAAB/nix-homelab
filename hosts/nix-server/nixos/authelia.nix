{config, ...}: let
  app-name = "authelia-pumpkin-rodeo";
  local-config-dir = "/nix/persist/" + "/${app-name}/";
in {
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}   -       -             -               -   - "
    "Z    ${local-config-dir}   740     ${app-name}   ${app-name}     -   - "
  ];
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
      authentication_backend = {
        file = {
          path = "${local-config-dir}/users_database.yml";
        };
      };
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
      disable_startup_check = false;
      filesystem = {
        filename = "${local-config-dir}/notification.txt";
      };
    };
  };
}
