{
  config,
  pkgs,
  ...
}: {
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
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
    hostName = "${config.networking.hostName}";
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
    };
    networkmanager.enable = true;
  };
  services.tailscale = {
    enable = true;
    extraUpFlags = ["--ssh"];
  };
}
