{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical;
in {
  options.nix-homelab.physical = with types; {
    enable = mkEnableOption (lib.mdDoc "Enable basic home-manager configs for physical machines");
  };
  config = mkIf cfg.enable {
    nix-homelab.physical = {
      fish.enable = true;
      git.enable = true;
      nvim.enable = true;
      home.enable = true;
      persist.enable = true;
    };
  };
}
