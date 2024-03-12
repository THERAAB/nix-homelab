{
  config,
  pkgs,
  lib,
  ...
}: let
  network = import ../../../assets/properties/network.properties.nix;
in {
  systemd = {
    services = {
      nixos-upgrade.onFailure = ["nixos-upgrade-on-failure.service"];
      nixos-upgrade-on-failure.script = ''
        TOKEN=`cat ${config.sops.secrets.gotify_homelab_token.path}`
        HOSTNAME=`${pkgs.nettools}/bin/hostname`

        ${pkgs.curl}/bin/curl   https://gotify.${network.domain}/message?token=$TOKEN                                   \
                                -F "title='$HOSTNAME' Upgrade Failed"                                                   \
                                -F "message=Upgrade failed on '$HOSTNAME', run journalctl -u nixos-upgrade for details" \
                                -F "priority=5"                                                                         \
      '';
      nix-flake-update = {
        script = ''
          sleep 10
          dir=/nix/persist/nix-homelab
          su -c "git -C $dir pull" raab
          nix flake update $dir --commit-lock-file
          su -c "git -C $dir push" raab
        '';
        path = with pkgs; [
          gitMinimal
          config.nix.package.out
          config.programs.ssh.package
          su
          coreutils-full
        ];
      };
    };
    timers.nix-flake-update = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = lib.mkDefault "Sun *-*-* 04:40:00";
        Persistent = "true";
        Unit = "nix-flake-update.service";
      };
    };
  };
  system.autoUpgrade = {
    enable = true;
    dates = lib.mkDefault "Sun *-*-* 04:50:00";
    flake = "github:THERAAB/nix-homelab/main";
    persistent = true;
    flags = [
      "--no-write-lock-file"
    ];
    allowReboot = true;
  };
}
