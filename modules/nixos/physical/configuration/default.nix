{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical.configuration;
in {
  options.nix-homelab.physical.configuration = with types; {
    enable = mkEnableOption (lib.mdDoc "Physical System configurations");
  };
  config = mkIf cfg.enable {
    nix = {
      # This will add each flake input as a registry
      # To make nix3 commands consistent with your flake
      registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

      # This will additionally add your inputs to the system's legacy channels
      # Making legacy nix commands consistent as well, awesome!
      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

      settings.auto-optimise-store = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };
    security.auditd.enable = true;
    services = {
      tailscale.enable = true;
      locate = {
        enable = true;
        package = pkgs.plocate;
      };
    };
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };
    environment.systemPackages = with pkgs; [
      neovim
      killall
      parted
      hdparm
      pciutils # for lspci
      lshw
      libva-utils
      clinfo
      wget
      unzip
      usbutils
      age
      sops
      ssh-to-age
      dos2unix
      hping
      fwts
      eza
      bat
      ripgrep
      tealdeer
      procs
      dust
      bottom
      zoxide
      ethtool
      kitty
      s0ix-selftest-tool
      openssl
      smartmontools
      git
    ];
    _module.args.nixinate = {
      host = config.networking.hostName;
      sshUser = "raab";
      buildOn = "remote";
      substituteOnTarget = true;
      hermetic = false;
    };
  };
}
