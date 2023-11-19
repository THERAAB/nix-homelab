{config, ...}: let
  app-name = "authelia-pumpkin-rodeo";
  local-config-dir = "/var/lib" + "/${app-name}";
  port = 9091;
  network = import ../../../share/network.properties.nix;
in {
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}                     -       -             -               -   - "
    "f    ${local-config-dir}/db.sqlite3          -       -             -               -   - "
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
      authentication_backend.file.path = config.sops.secrets.authelia_users_db.path;
      session = {
        name = "authelia_pumpkin_rodeo";
        expiration = "12h";
        inactivity = "45m";
        remember_me_duration = "1M";
        domain = "pumpkin.rodeo";
      };
      regulation = {
        max_retries = 5;
        find_time = "10m";
        ban_time = "1h";
      };
      access_control = {
        default_policy = "deny";
        networks = [
          {
            name = "internal";
            networks = [
              "192.168.3.2/32"
              "192.168.2.20/32"
              "192.168.1.1/24"
              "10.88.0.1/16"
              "10.89.0.1/24"
              "10.99.0.1/24"
              "10.94.0.1/24"
              "100.64.0.0/10"
            ];
          }
        ];
        rules = [
          {
            domain = ["auth.pumpkin.rodeo"];
            policy = "bypass";
          }
          {
            domain = ["pumpkin.rodeo" "*.pumpkin.rodeo" ];
            policy = "bypass";
            networks = ["internal"];
          }
          {
            domain = ["pumpkin.rodeo" "*.pumpkin.rodeo" ];
            policy = "two_factor";
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
