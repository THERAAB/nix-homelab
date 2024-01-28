{config, ...}: {
  #TODO: enable in default.nix
  services.restic.backups.server = {
    exclude = [
      "**/.git"
    ];
    initialize = true;
    passwordFile = config.sops.secrets.restic_password.path;
    paths = [
      "/nix/persist"
      "/sync"
    ];
    repository = "/backups";
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 75"
    ];
  };
}
