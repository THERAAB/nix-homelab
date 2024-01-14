{
  config,
  pkgs,
  lib,
  ...
}: {
  systemd.services = {
    nixos-upgrade.onFailure = ["nixos-upgrade-on-failure.service"];
    nixos-upgrade-on-failure = {
      script = ''
        TOKEN=`cat ${config.sops.secrets.gotify_homelab_token.path}`
        HOSTNAME=`${pkgs.nettools}/bin/hostname`

        ${pkgs.curl}/bin/curl   https://gotify.pumpkin.rodeo/message?token=$TOKEN                                       \
                                -F "title='$HOSTNAME' Upgrade Failed"                                                   \
                                -F "message=Upgrade failed on '$HOSTNAME', run journalctl -u nixos-upgrade for details" \
                                -F "priority=5"                                                                         \
      '';
    };
  };

  system.autoUpgrade = {
    enable = true;
    dates = lib.mkDefault "Sun *-*-* 04:30:00";
    flake = "/nix/persist/nix-homelab";
    persistent = true;
    flags = [
      "--recreate-lock-file"
    ];
    allowReboot = true;
  };
}
