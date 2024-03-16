{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.git;
in {
  options.nix-homelab.workstation.git = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup git");
    config-dir = mkOption {
      type = str;
      default = "/nix/persist/home/raab/.config";
    };
  };
  config = mkIf cfg.enable {
    programs.git = {
      includes = [
        {path = "${cfg.config-dir}/.gitconfig";}
      ];
      enable = true;
      userName = "THERAAB";
      extraConfig = {
        push.autoSetupRemote = true;
      };
    };
  };
}
