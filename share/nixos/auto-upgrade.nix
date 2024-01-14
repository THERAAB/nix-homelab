{
  config,
  pkgs,
  lib,
  ...
}: let
  network = import ../network.properties.nix;
in {
  systemd.services = {
    nixos-upgrade.onFailure = ["nixos-upgrade-on-failure.service"];
    nixos-upgrade-on-failure = {
      script = ''
        TOKEN=`cat ${config.sops.secrets.gotify_homelab_token.path}`
        HOSTNAME=`${pkgs.nettools}/bin/hostname`

        ${pkgs.curl}/bin/curl   https://gotify.${network.domain}/message?token=$TOKEN                                       \
                                -F "title='$HOSTNAME' Upgrade Failed"                                                   \
                                -F "message=Upgrade failed on '$HOSTNAME', run journalctl -u nixos-upgrade for details" \
                                -F "priority=5"                                                                         \
      '';
    };
  };

  system.autoUpgrade = {
    enable = true;
    dates = lib.mkDefault "Sun *-*-* 04:30:00";
    flake = "github:THERAAB/nix-homelab/main";
    persistent = true;
    flags = [
      "--no-write-lock-file"
    ];
    allowReboot = true;
  };
}
