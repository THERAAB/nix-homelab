{
  pkgs,
  config,
  properties,
  ...
}: let
  port = properties.ports.backrest;
in {
  users.groups.restic.gid = properties.users.restic.gid;
  services.restic.backups."nix-server" = {
    exclude = [
      ".git"
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
      "var/lib/containers/storage"
      "var/lib/private/AdGuardHome/data"
      "var/lib/jellyfin/data/metadata/library"
      "var/log/"
      "var/cache/"
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
  environment.systemPackages = with pkgs; [
    rclone
    backrest
  ];
  systemd.services.backrest = {
    description = "Launch backrest to take care of backups";
    wantedBy = ["multi-user.target"];
    requires = ["network-online.target"];
    script = "backrest";
    path = [pkgs.backrest pkgs.rclone];
    environment = {
      BACKREST_PORT = "0.0.0.0:${toString port}";
    };
    serviceConfig = {
      Type = "simple";
      User = "root";
    };
  };
  environment.persistence."/nix/persist/system".directories = [
    "/root/.local/share/backrest"
    "/root/.config/backrest"
  ];
  services.caddy.virtualHosts = {
    "restic.${properties.network.domain}" = {
      useACMEHost = "${properties.network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy ${properties.network.nix-hypervisor.local.ip}:${toString port}
      '';
    };
  };
  services.gatus.settings.endpoints = [
    {
      name = "Backrest";
      url = "https://restic.${properties.network.domain}/";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
  ];
  networking.firewall.allowedTCPPorts = [port];
  systemd.services = {
    restic-backups-nix-server.onFailure = ["restic-on-failure.service"];
    restic-on-failure.script = ''
      TOKEN=`cat ${config.sops.secrets.gotify_homelab_token.path}`
      HOSTNAME=`${pkgs.nettools}/bin/hostname`

      ${pkgs.curl}/bin/curl   https://gotify.${properties.network.domain}/message?token=$TOKEN                                                     \
                              -F "title='$HOSTNAME' Restic backup Failed"                                                               \
                              -F "message=Restic backup failed on '$HOSTNAME', run journalctl -u restic-backups-nix-server for details" \
                              -F "priority=5"                                                                                           \
    '';
  };
}
