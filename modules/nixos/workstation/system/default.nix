{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.system;
in {
  options.nix-homelab.workstation.system = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup system");
  };
  config = mkIf cfg.enable {
    security.auditd.enable = true;
    nix.settings = {
      allowed-users = ["@wheel"];
      substituters = ["https://cache.pumpkin.rodeo"];
      trusted-public-keys = ["cache.pumpkin.rodeo:IqbrtbXMzwCjSVZ/sWowaPXtjS+CtpCpStmabZI2TSo="];
    };
    programs.dconf.enable = true;
    environment.variables.EDITOR = "nvim";
    fonts.packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono" "Noto"];})
    ];
    services.locate = {
      enable = true;
      package = pkgs.plocate;
      localuser = null;
    };
  };
}
