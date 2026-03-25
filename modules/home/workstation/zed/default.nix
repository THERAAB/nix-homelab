{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab;
let
  cfg = config.nix-homelab.workstation.zed;
in
{
  options.nix-homelab.workstation.zed = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup zed");
  };
  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [ "nix" ];
      enableMcpIntegration = false;
      mutableUserSettings = false;
      mutableUserTasks = false;
      mutableUserKeymaps = false;
      mutableUserDebug = false;
      userSettings = {
        vim_mode = true;
        autosave = "on_focus_change";
      };
    };
  };
}
