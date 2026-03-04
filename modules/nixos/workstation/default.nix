{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation;
in {
  options.nix-homelab.workstation = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup workstation");
  };
  config = mkIf cfg.enable {
    nix-homelab = {
      workstation = {
        auto-upgrade.enable = true;
        pkgs.enable = true;
        gnome.enable = true;
        hardware.enable = true;
        syncthing.enable = true;
        system.enable = true;
      };
      physical.enable = true;
    };
    programs.firefox.enable = true;
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
      fonts = {
        sansSerif.name = "NotoSans Nerd Font";
        monospace.name = "JetBrainsMono Nerd Font";
        serif = config.stylix.fonts.sansSerif;
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
