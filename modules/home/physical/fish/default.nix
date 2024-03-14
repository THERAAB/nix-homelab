{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical.fish;
in {
  options.nix-homelab.physical.fish = with types; {
    enable = mkEnableOption (lib.mdDoc "Configure Fish shell");
  };
  config = mkIf cfg.enable {
    programs = {
      fish = {
        enable = true;
        shellAliases = {
          cat = "bat --theme=base16-256";
          grep = "rg";
          ps = "procs";
          du = "dust";
          htop = "btm";
        };
      };
      zoxide = {
        enable = true;
        options = ["--cmd cd"];
      };
      eza = {
        enable = true;
        enableAliases = true;
      };
    };
  };
}
