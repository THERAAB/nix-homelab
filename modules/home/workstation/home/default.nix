{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.home;
in {
  options.nix-homelab.workstation.home = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup home");
  };
  config = mkIf cfg.enable {
    home = {
      username = "raab";
      homeDirectory = "/home/raab";
      stateVersion = "23.11";
    };
    programs.home-manager.enable = true;
    home.packages = with pkgs; [
      gimp
      vmware-horizon-client
      discord
      imagemagick
      libreoffice-fresh
      psutils
      unzip
      zoom-us
      glibc
      file
      ncdu_2
      tree
      strace
      ventoy-full
      lm_sensors
      ffmpeg
      audible-cli
      aaxtomp3
      neofetch
    ];
  };
}
