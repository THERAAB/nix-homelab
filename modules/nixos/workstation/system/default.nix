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
    users.users.raab.extraGroups = ["audio" "openrazer" "plugdev" "input" "syncthing"];
    nix.settings = {
      allowed-users = ["@wheel"];
      substituters = ["https://cache.pumpkin.rodeo"];
      trusted-public-keys = ["cache.pumpkin.rodeo:IqbrtbXMzwCjSVZ/sWowaPXtjS+CtpCpStmabZI2TSo="];
    };
    programs.dconf.enable = true;
    fonts.packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono" "Noto"];})
    ];
  };
}
