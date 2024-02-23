{pkgs, ...}: {
  security.auditd.enable = true;
  services = {
    locate = {
      enable = true;
      package = pkgs.plocate;
      localuser = null;
    };
  };
}
