{pkgs, ...}: {
  security.auditd.enable = true;
  nix.settings.allowed-users = ["@wheel"];

  #OpenSSH
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.locate = {
    enable = true;
    locate = pkgs.plocate;
    localuser = null;
  };

  environment.variables.EDITOR = "nvim";
}
