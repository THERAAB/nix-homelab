{pkgs, ...}: {
  environment = {
    variables.TERM = "xterm-256color";
    noXlibs = false;
    systemPackages = with pkgs; [
      fuse-overlayfs
    ];
  };
  users.allowNoPasswordLogin = true;
  security.sudo.execWheelOnly = true;
}
