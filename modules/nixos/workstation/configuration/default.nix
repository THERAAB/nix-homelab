{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.configuration;
in {
  options.nix-homelab.workstation.configuration = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup configuration.nix");
  };
  config = mkIf cfg.enable {
    nix = {
      # This will add each flake input as a registry
      # To make nix3 commands consistent with your flake
      registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
      # This will additionally add your inputs to the system's legacy channels
      # Making legacy nix commands consistent as well, awesome!
      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
      # Flake setup
      package = pkgs.nixVersions.stable;
      settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
      };
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };
    environment.systemPackages = with pkgs; [
      killall
      pulseaudio # needed to use pactl on pipewire
      dmidecode
      parted
      pciutils # for lspci
      wget
      unzip
      usbutils
      age
      sops
      ssh-to-age
      libnotify
      wmctrl
      gnome-text-editor
      gnome.nautilus
      bat
      ripgrep
      tealdeer
      procs
      du-dust
      bottom
      helix
      kitty
      gnome.ghex
      pavucontrol
      xorg.xlsclients
      nil
      neovim
      alejandra
      wl-clipboard
      acpica-tools
      gparted
      acpi
      vim
      hw-probe
      google-chrome
      nvme-cli
      s0ix-selftest-tool
      stress
      libva-utils
      sysfsutils
      git
    ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
    system.stateVersion = "23.11"; # Did you read the comment?
  };
}
