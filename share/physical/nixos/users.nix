{...}: let
  users = import ../../users.properties.nix;
in {
  users = {
    groups = {
      users.gid = 100;
      nfsnobody = {};
      restic.gid = users.restic.gid;
    };
    users = {
      root.initialHashedPassword = "$6$89oRObq6lBVqE6Pz$lsm8TXKsGsYZ3HsmbshaTRbecNRMtRQmUUWZS2fubs6y8vF9lLp01dbrhgjGvGPco7qLdEN.hRQ0uisscBanM1";
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
