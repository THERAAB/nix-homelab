{pkgs, ...}: {
  security.auditd.enable = true;
  services = {
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
