{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.server.users;
in {
  options.nix-homelab.server.users = with types; {
    enable = mkEnableOption (lib.mdDoc "Shared system users");
  };
  config = mkIf cfg.enable {
    users = {
      groups = {
        nfsnobody = {};
        restic.gid = properties.users.restic.gid;
      };
      users = {
        root.extraGroups = ["restic"];
        nfsnobody = {
          uid = properties.users.nfsnobody.uid;
          group = "nfsnobody";
          extraGroups = ["restic"];
          isSystemUser = true;
        };
      };
    };
  };
}
