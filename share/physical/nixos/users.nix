{properties, ...}: {
  users = {
    groups = {
      users.gid = 100;
      nfsnobody = {};
      restic.gid = properties.users.restic.gid;
    };
    users = {
      root = {
        # $ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd
        initialHashedPassword = "$6$89oRObq6lBVqE6Pz$lsm8TXKsGsYZ3HsmbshaTRbecNRMtRQmUUWZS2fubs6y8vF9lLp01dbrhgjGvGPco7qLdEN.hRQ0uisscBanM1";
        extraGroups = ["restic"];
      };
      raab = {
        isNormalUser = true;
        extraGroups = ["networkmanager" "wheel" "keys"];
        initialHashedPassword = "$6$89oRObq6lBVqE6Pz$lsm8TXKsGsYZ3HsmbshaTRbecNRMtRQmUUWZS2fubs6y8vF9lLp01dbrhgjGvGPco7qLdEN.hRQ0uisscBanM1";
        uid = 1000;
      };
      nfsnobody = {
        uid = properties.users.nfsnobody.uid;
        group = "nfsnobody";
        extraGroups = ["restic"];
        isSystemUser = true;
      };
    };
  };
}
