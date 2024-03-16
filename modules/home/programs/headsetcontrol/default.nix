{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.programs.headsetcontrol;
in {
  options.nix-homelab.programs.headsetcontrol = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup headset-lights");
  };
  config = mkIf cfg.enable {
    systemd.user = {
      services.headset-lights.Service.ExecStart = "${pkgs.headsetcontrol}/bin/headsetcontrol -l 0";
      timers.headset-lights = {
        Timer = {
          Unit = "headset-lights.service";
          OnCalendar = "*:0/1"; # minutely
        };
        Install.WantedBy = ["timers.target"];
      };
    };
    home.packages = with pkgs; [
      headsetcontrol
    ];
  };
}
