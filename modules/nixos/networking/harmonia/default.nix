{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.networking.harmonia;
in {
  options.nix-homelab.networking.harmonia = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup network fileshare permissions");
  };
  config = mkIf cfg.enable {
    services.harmonia = {
      enable = true;
      signKeyPath = config.sops.secrets.harmonia_secret.path;
    };
    nix.settings.allowed-users = ["harmonia"];
  };
}
