{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.core.flakes;
in {
  options.nix-homelab.core.flakes = with types; {
    enable = mkEnableOption (lib.mdDoc "Flakes");
  };
  config = mkIf cfg.enable {
    nix = {
      # Flake setup
      package = pkgs.nixVersions.stable;
      settings.experimental-features = "nix-command flakes";
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
  };
}
