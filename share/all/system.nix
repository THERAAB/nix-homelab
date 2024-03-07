{
  pkgs,
  lib,
  ...
}: {
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
  services.openssh.enable = false;
}
