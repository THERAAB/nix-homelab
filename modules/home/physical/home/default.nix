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
    enable = mkEnableOption (lib.mdDoc "Default home-manager values");
  };
  config = mkIf cfg.enable {
    home = {
      file = {
        ".config/nix/nix.conf" = {
          text = ''experimental-features = nix-command flakes'';
          executable = false;
        };
      };
      username = "raab";
      homeDirectory = "/home/raab";
      stateVersion = "23.11";
    };
    programs.home-manager.enable = true;
    home.packages = with pkgs; [
      ncdu
      lm_sensors
    ];
  };
}
