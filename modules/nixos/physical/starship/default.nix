{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical.starship;
in {
  options.nix-homelab.physical.starship = with types; {
    enable = mkEnableOption (lib.mdDoc "Starship prompt");
  };
  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        hostname = {
          ssh_only = false;
          format = "on [$hostname](bold yellow) ";
        };
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
        directory = {
          format = "at [$path]($style)[$read_only]($read_only_style) ";
          read_only = " ";
        };
        git_branch = {
          format = "in [$symbol$branch(:$remote_branch)]($style) ";
        };
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        cmd_duration = {
          min_time = 100;
        };
      };
    };
  };
}
