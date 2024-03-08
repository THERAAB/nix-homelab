{
  pkgs,
  config,
  ...
}: let
  network = import ../../share/network.properties.nix;
  users = import ../../share/users.properties.nix;
in {
  users.groups.restic.gid = users.restic.gid;
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
      "cache"
      "logs"
      "metadata"
      "*.log"
      "flatnotes/.flatnotes"
      "var/lib/containers/storage"
      "var/lib/private/AdGuardHome/data"
      "var/lib/private/photoprism/cache"
      "var/lib/jellyfin/data/metadata/library"
      "var/log/"
      "var/cache/"
      "microvms/*/storage/journal/"
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
  systemd.services = {
    restic-backups-nix-server.onFailure = ["restic-on-failure.service"];
    restic-on-failure.script = ''
      TOKEN=`cat ${config.sops.secrets.gotify_homelab_token.path}`
      HOSTNAME=`${pkgs.nettools}/bin/hostname`

      ${pkgs.curl}/bin/curl   https://gotify.${network.domain}/message?token=$TOKEN                                                     \
                              -F "title='$HOSTNAME' Restic backup Failed"                                                               \
                              -F "message=Restic backup failed on '$HOSTNAME', run journalctl -u restic-backups-nix-server for details" \
                              -F "priority=5"                                                                                           \
    '';
  };
}
