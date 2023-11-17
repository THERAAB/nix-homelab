{config, ...}: {
  services.authelia.instances.pumpkin-rodeo = {
    enable = true;
    secrets.storageEncryptionKeyFile = config.sops.secrets.authelia_storage_secret.path;
    secrets.jwtSecretFile = config.sops.secrets.authelia_jwt_secret.path;
    settings = {
      theme = "dark";
      default_2fa_method = "totp";
      log.level = "debug";
      server.disable_healthcheck = true;
    };
  };
}
