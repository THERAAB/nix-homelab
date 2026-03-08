{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.beszel-agent;
in {
  options.nix-homelab.wrappers.beszel-agent = with types; {
    enable = mkEnableOption (lib.mdDoc "Beszel agent");
  };
  config = mkIf cfg.enable {
    services.beszel.agent = {
      enable = true;
      openFirewall = true;
      smartmon.enable = true;
    };
  };
}
