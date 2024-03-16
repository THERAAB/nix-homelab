{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.auto-upgrade;
in {
  options.nix-homelab.workstation.auto-upgrade = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup auto-upgrade");
  };
  config = mkIf cfg.enable {
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
      nix-flake-update = {
        script = ''
          sleep 30
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
        wantedBy = ["network-online.target"];
        after = ["network-online.target"];
      };
    };
    system.autoUpgrade = {
      enable = true;
      dates = "weekly";
      flake = "github:THERAAB/nix-homelab/main";
      randomizedDelaySec = "45min";
      operation = "boot";
      persistent = true;
      flags = [
        "--no-write-lock-file"
      ];
      allowReboot = false;
    };
  };
}
