{
  pkgs,
  config,
  ...
}: let
  network = import ../../share/network.properties.nix;
in {
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
  systemd = {
    services = {
      restic-backups-nix-server.onFailure = ["restic-on-failure.service"];
      restic-on-failure.script = ''
        TOKEN=`cat ${config.sops.secrets.gotify_homelab_token.path}`
        HOSTNAME=`${pkgs.nettools}/bin/hostname`

        ${pkgs.curl}/bin/curl   https://gotify.${network.domain}/message?token=$TOKEN                                                     \
                                -F "title='$HOSTNAME' Upgrade Failed"                                                                     \
                                -F "message=Restic backup failed on '$HOSTNAME', run journalctl -u restic-backups-nix-server for details" \
                                -F "priority=5"                                                                                           \
      '';
    };
  };
}
