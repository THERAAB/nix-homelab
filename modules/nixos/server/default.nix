{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.server;
in {
  options.nix-homelab.server = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup workstation");
  };
  config = mkIf cfg.enable {
    nix-homelab = {
      physical.enable = true;
      server = {
        hardware.enable = true;
        netdata.enable = true;
        smartd.enable = true;
        users.enable = true;
      };
    };
  };
}
