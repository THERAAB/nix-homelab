{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.fish;
in {
  options.nix-homelab.workstation.fish = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup fish");
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
      atuin.enable = true;
      eza = {
        enable = true;
        enableAliases = true;
      };
    };
  };
}
