{lib, ...}: {
  microvm = {
    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
      }
    ];
    mem = lib.mkDefault 2048;
    vcpu = lib.mkDefault 1;
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  users = {
    mutableUsers = false;
    users = {
      # $ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd
      root = {
        initialHashedPassword = "$6$89oRObq6lBVqE6Pz$lsm8TXKsGsYZ3HsmbshaTRbecNRMtRQmUUWZS2fubs6y8vF9lLp01dbrhgjGvGPco7qLdEN.hRQ0uisscBanM1";
      };
      raab = {
        isNormalUser = true;
        description = "raab";
        extraGroups = ["networkmanager" "wheel"];
        initialHashedPassword = "$6$89oRObq6lBVqE6Pz$lsm8TXKsGsYZ3HsmbshaTRbecNRMtRQmUUWZS2fubs6y8vF9lLp01dbrhgjGvGPco7qLdEN.hRQ0uisscBanM1";
        uid = 1000;
      };
    };
  };
}
