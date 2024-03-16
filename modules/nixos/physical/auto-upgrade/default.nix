{
  config,
  pkgs,
  lib,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical.autoUpgrade;
in {
  options.nix-homelab.physical.autoUpgrade = with types; {
    enable = mkEnableOption (lib.mdDoc "System autoupgrade");
  };
  config = mkIf cfg.enable {
    systemd = {
      services = {
        nixos-upgrade.onFailure = ["nixos-upgrade-on-failure.service"];
        nixos-upgrade-on-failure.script = ''
          TOKEN=`cat ${config.sops.secrets.gotify_homelab_token.path}`
          HOSTNAME=`${pkgs.nettools}/bin/hostname`

          ${pkgs.curl}/bin/curl   https://gotify.${properties.network.domain}/message?token=$TOKEN                        \
                                  -F "title='$HOSTNAME' Upgrade Failed"                                                   \
                                  -F "message=Upgrade failed on '$HOSTNAME', run journalctl -u nixos-upgrade for details" \
                                  -F "priority=5"                                                                         \
        '';
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
      allowReboot = mkDefault true;
    };
  };
}
