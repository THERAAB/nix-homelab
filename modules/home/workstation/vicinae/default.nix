{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.vicinae;
in {
  options.nix-homelab.workstation.vicinae = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup vicinae`");
  };
  config = mkIf cfg.enable {
    programs.vicinae = {
      enable = true;
      systemd = {
        enable = true;
      };
      settings = {
        font.family = "system";
        launcher_window.opacity = lib.mkForce 0.92;
        pop_to_root_on_close = true;
        theme.dark.icon_theme = "Papirus-Dark";
        favorites = [];
      };
    };
  };
}
