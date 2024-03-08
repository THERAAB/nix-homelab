{...}: {
  users = {
    mutableUsers = false;
    users = { #TODO: move
      # $ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd
      raab = {
        isNormalUser = true;
        description = "raab";
        extraGroups = ["networkmanager" "wheel" "keys"];
        initialHashedPassword = "$6$89oRObq6lBVqE6Pz$lsm8TXKsGsYZ3HsmbshaTRbecNRMtRQmUUWZS2fubs6y8vF9lLp01dbrhgjGvGPco7qLdEN.hRQ0uisscBanM1";
        uid = 1000;
      };
    };
  };
}
