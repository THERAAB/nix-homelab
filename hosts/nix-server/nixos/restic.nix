{config, ...}: {
  #TODO: enable in default.nix
  services.restic.backups."nix-server" = {
    exclude = [
      ".git"
      ".photoprism"
      ".stfolder"
      ".stversions"
      ".ssh"
      ".cache"
      ".tmp"
      ".log"
      ".Trash"
      "/nix/persist/system/var/lib/containers/storage"
      "/nix/persist/system/var/lib/private/AdGuardHome/data"
      "/nix/persist/system/var/lib/private/photoprism/cache"
      "/nix/persist/system/var/lib/jellyfin/data/metadata/library"
      "/nix/persist/system/var/log/"
      "/nix/persist/system/var/cache/"
      "/nix/persist/system/etc/"
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
