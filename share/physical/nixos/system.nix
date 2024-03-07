{pkgs, ...}: {
  security.auditd.enable = true;
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
    locate = {
      enable = true;
      package = pkgs.plocate;
      localuser = null;
    };
  };
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
