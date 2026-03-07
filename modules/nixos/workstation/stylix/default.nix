{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.stylix;
in {
  options.nix-homelab.workstation.stylix = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup stylix");
  };
  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/jabuti.yaml";
      override.base03 = "5e617f";
      fonts = {
        sansSerif.name = "NotoSans Nerd Font";
        serif.name = "NotoSans Nerd Font";
        monospace.name = "JetBrainsMono Nerd Font";
        sizes = {
          terminal = 12;
          applications = 11;
          popups = 10;
          desktop = 10;
        };
      };
      polarity = "dark";
    };
    environment.systemPackages = with pkgs; [
      base16-schemes
    ];
  };
}
