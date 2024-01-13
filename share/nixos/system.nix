{pkgs, ...}: {
  security.auditd.enable = true;
  nix.settings.allowed-users = ["@wheel"];
  services = {
    openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    locate = {
      enable = true;
      package = pkgs.plocate;
      localuser = null;
    };
  };
  environment.variables.EDITOR = "nvim";
}
