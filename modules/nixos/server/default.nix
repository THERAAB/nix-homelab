{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.server;
in {
  options.nix-homelab.server = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup Server");
  };
  config = mkIf cfg.enable {
    nix-homelab = {
      physical.enable = true;
      server = {
        hardware.enable = true;
        netdata.enable = true;
        smartd.enable = true;
        users.enable = true;
      };
    };
    stylix = {
      # Enable stylix so nix doesn't complain about missing options, but disable everything
      enable = true;
      autoEnable = false;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
    };
  };
}
