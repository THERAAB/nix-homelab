{pkgs, ...}: {
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.utf8";
  environment = {
    variables = {
      EDITOR = "nvim";
      TERM = "xterm-256color";
    };
    systemPackages = with pkgs; [
      fuse-overlayfs
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
  fileSystems = {
    "/etc/ssh".neededForBoot = true;
    "/var/lib".neededForBoot = true;
  };
  environment.noXlibs = false;
  services.tailscale = {
    enable = true;
    extraUpFlags = ["--ssh"];
  };
}
