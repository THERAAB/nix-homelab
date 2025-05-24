{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.pkgs;
in {
  options.nix-homelab.workstation.pkgs = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup home");
  };
  config = mkIf cfg.enable {
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
      tree
      strace
      ventoy-full
      ffmpeg
      audible-cli
      aaxtomp3
      neofetch
    ];
  };
}
