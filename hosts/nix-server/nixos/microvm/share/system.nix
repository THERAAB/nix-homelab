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
    mem = 16384;
    vcpu = 2;
    hypervisor = lib.mkDefault "cloud-hypervisor";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = lib.mkDefault "23.11";
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
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.utf8";
  environment = {
    variables = {
      EDITOR = "nvim";
      TERM = "xterm-256color";
    };
    systemPackages = with pkgs; [
      neovim
    ];
  };
  networking.firewall.enable = true;
}