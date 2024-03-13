{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.core.system;
in {
  options.nix-homelab.core.system = with types; {
    enable = mkEnableOption (lib.mdDoc "System");
  };
  config = mkIf cfg.enable {
    system.stateVersion = "23.11";
    nix.settings.allowed-users = ["@wheel"];
    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.utf8";
    environment = {
      variables = {
        EDITOR = "nvim";
      };
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
