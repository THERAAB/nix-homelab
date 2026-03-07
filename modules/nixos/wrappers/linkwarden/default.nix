{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.linkwarden;
  port = properties.ports.linkwarden;
  host = properties.network.nix-hypervisor.local.ip;
in {
  options.nix-homelab.wrappers.linkwarden = with types; {
    enable = mkEnableOption (lib.mdDoc "Linkwarden");
  };
  config = mkIf cfg.enable {
    services.linkwarden = {
      enable = true;
      enableRegistration = false;
      host = host;
      port = port;
      environment.NEXTAUTH_URL = "http://${host}:${toString port}/api/v1/auth";
      secretFiles.NEXTAUTH_SECRET = config.sops.secrets.linkwarden_nextauth.path;
    };
  };
}
