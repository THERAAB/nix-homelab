{...}: let
  users = import ../../users.properties.nix;
in {
  users = {
    groups = {
      nfsnobody = {};
      restic.gid = users.restic.gid;
    };
    users = {
      root.extraGroups = ["restic"];
      nfsnobody = {
        uid = users.nfsnobody.uid;
        group = "nfsnobody";
        extraGroups = ["restic"];
        isSystemUser = true;
      };
    };
  };
}