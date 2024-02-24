{...}: let
  users = import ../../../share/users.properties.nix;
in {
  users = {
    mutableUsers = false;
    groups = {
      users.gid = 100;
      nfsnobody = {};
      media.gid = users.media.gid;
      restic.gid = users.restic.gid;
    };
  };
  users = {
    # $ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd
    root = {
      extraGroups = ["restic"];
      initialHashedPassword = "$6$89oRObq6lBVqE6Pz$lsm8TXKsGsYZ3HsmbshaTRbecNRMtRQmUUWZS2fubs6y8vF9lLp01dbrhgjGvGPco7qLdEN.hRQ0uisscBanM1";
    };
    raab = {
      isNormalUser = true;
      description = "raab";
      extraGroups = ["networkmanager" "wheel" "keys"];
      initialHashedPassword = "$6$89oRObq6lBVqE6Pz$lsm8TXKsGsYZ3HsmbshaTRbecNRMtRQmUUWZS2fubs6y8vF9lLp01dbrhgjGvGPco7qLdEN.hRQ0uisscBanM1";
      uid = 1000;
    };
    nfsnobody = {
      uid = users.nfsnobody.uid;
      group = "nfsnobody";
      extraGroups = ["media" "restic"];
      isSystemUser = true;
    };
  };
}
