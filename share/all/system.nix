{pkgs, ...}: {
  services = {
    openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    tailscale = {
      enable = true;
      extraUpFlags = ["--ssh"];
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
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
    };
    networkmanager.enable = true;
  };
}
