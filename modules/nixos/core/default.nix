{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.core;
in {
  options.nix-homelab.core = with types; {
    enable = mkEnableOption (lib.mdDoc "Core setup");
  };
  config = mkIf cfg.enable {
    nix = {
      # Flake setup
      package = pkgs.nixVersions.stable;
      settings.experimental-features = "nix-command flakes";
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
    system.stateVersion = "23.11";
    nix.settings.allowed-users = ["@wheel"];
    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";
    environment = {
      variables.EDITOR = "nvim";
      systemPackages = with pkgs; [
        neovim
        pciutils
        usbutils
      ];
    };
    networking = {
      firewall.enable = true;
      networkmanager.enable = lib.mkDefault true;
    };
    services.openssh.enable = lib.mkDefault false; # tailscale has it's own ssh agent
    users.mutableUsers = false;
  };
}
