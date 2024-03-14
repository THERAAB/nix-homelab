{
  config,
  lib,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical;
in {
  options.nix-homelab.physical = with types; {
    enable = mkEnableOption (lib.mdDoc "Physical system core setup");
    hostName = mkOption {
      type = str;
    };
  };
  config = mkIf cfg.enable {
    nix-homelab = {
      core.enable = true;
      physical = {
        autoUpgrade.enable = true;
        configuration.enable = true;
        fish.enable = true;
        hardware.enable = true;
        netdata.enable = true;
        nox.enable = true;
        smartd.enable = true;
        starship.enable = true;
        system.enable = true;
        users.enable = true;
        hardware-configuration.enable = true;
      };
    };
  };
}
