{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical.users;
in {
  options.nix-homelab.physical.users = with types; {
    enable = mkEnableOption (lib.mdDoc "Shared system users");
  };
  config = mkIf cfg.enable {
    users = {
      groups.users.gid = 100;
      users = {
        # $ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd
        root.initialHashedPassword = "$6$89oRObq6lBVqE6Pz$lsm8TXKsGsYZ3HsmbshaTRbecNRMtRQmUUWZS2fubs6y8vF9lLp01dbrhgjGvGPco7qLdEN.hRQ0uisscBanM1";
        raab = {
          isNormalUser = true;
          extraGroups = ["networkmanager" "wheel" "keys"];
          initialHashedPassword = "$6$89oRObq6lBVqE6Pz$lsm8TXKsGsYZ3HsmbshaTRbecNRMtRQmUUWZS2fubs6y8vF9lLp01dbrhgjGvGPco7qLdEN.hRQ0uisscBanM1";
          uid = 1000;
        };
      };
    };
  };
}
