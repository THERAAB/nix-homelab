{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  user-themes-dir = "/home/raab/.config/ulauncher/user-themes/";
  system-themes-dir = "/nix/persist/nix-homelab/modules/home/workstation/ulauncher/custom";
  cfg = config.nix-homelab.workstation.ulauncher;
in {
  options.nix-homelab.workstation.ulauncher = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup Ulauncher");
  };
  config = mkIf cfg.enable {
    systemd.user.services.ulauncher = {
      Install.WantedBy = ["graphical-session.target"];
      Unit.After = ["graphical-session.target"];
      Service.ExecStart = toString (pkgs.writeShellScript "ulauncher-start" ''
        mkdir -p ${user-themes-dir}
        cp -r ${system-themes-dir} ${user-themes-dir}
        ${pkgs.ulauncher}/bin/ulauncher --hide-window
      '');
    };
    home.packages = with pkgs; [
      ulauncher
    ];
  };
}
