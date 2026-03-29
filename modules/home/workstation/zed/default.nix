{
  lib,
  config,
  pkgs,
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
      extraPackages = with pkgs; [
        nixd
        shellcheck
      ];
      enableMcpIntegration = false;
      mutableUserSettings = false;
      mutableUserTasks = false;
      mutableUserKeymaps = false;
      mutableUserDebug = false;
      userSettings = {
        vim_mode = true;
        autosave = "on_focus_change";
        ui_font_size = lib.mkForce 14;
        buffer_font_size = lib.mkForce 14;
        auto_update = false;
        relative_line_numbers = true;
        terminal = {
          copy_on_select = false;
          dock = "bottom";
          env.TERM = "kitty";
          shell = "system";
        };
        lsp.nix.binary.path_lookup = true;
      };
    };
  };
}
