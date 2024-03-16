{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.programs.libinput-gestures;
  local-dir = "/home/raab/.config";
  config-dir = "/nix/persist/nix-homelab/modules/home/programs/libinput-gestures";
  evemu-script-name = "evemu-event-sendkeys.sh";
  libinput-conf-name = "libinput-gestures.conf";
in {
  options.nix-homelab.programs.libinput-gestures = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup libinput-gestures");
  };
  config = mkIf cfg.enable {
    systemd.user.services.libinput-gestures = {
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        Type = "simple";
        ExecStart = toString (pkgs.writeShellScript "libinput-gestures-start" ''
          cp -f ${config-dir}/${libinput-conf-name} ${local-dir}
          cp -f ${config-dir}/${evemu-script-name} ${local-dir}
          chmod +x ${local-dir}/${evemu-script-name}
          ${pkgs.libinput-gestures}/bin/libinput-gestures
        '');
        Environment = "DISPLAY=:0";
      };
    };

    home.packages = with pkgs; [
      libinput
      libinput-gestures
      evemu
    ];
  };
}
