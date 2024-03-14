{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical.git;
  local-config-dir = "/nix/persist/home/raab/.config/";
in {
  options.nix-homelab.physical.git = with types; {
    enable = mkEnableOption (lib.mdDoc "Configure git for user");
  };
  config = mkIf cfg.enable {
    programs.git = {
      includes = [
        {path = "${local-config-dir}/.gitconfig";}
      ];
      enable = true;
      userName = "THERAAB";
      extraConfig = {
        push.autoSetupRemote = true;
      };
    };
  };
}
