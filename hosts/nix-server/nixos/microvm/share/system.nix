{
  pkgs,
  lib,
  ...
}: {
  microvm = {
    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
      }
    ];
    mem = 2048;
    vcpu = 1;
    hypervisor = "cloud-hypervisor";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.11";
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
  services.openssh = {
    enable = true;
  };
  networking.nameservers = ["1.1.1.1"];
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.utf8";
  environment.shells = with pkgs; [fish];
  users.defaultUserShell = pkgs.fish;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };
}
