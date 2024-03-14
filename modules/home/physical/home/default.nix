{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical.home;
in {
  options.nix-homelab.physical.home = with types; {
    enable = mkEnableOption (lib.mdDoc "System");
  };
  config = mkIf cfg.enable {
    home = {
      username = "raab";
      homeDirectory = "/home/raab";
      stateVersion = "23.11";
    };
    programs.home-manager.enable = true;
    home.packages = with pkgs; [
      ncdu_2
      lm_sensors
    ];
  };
}
