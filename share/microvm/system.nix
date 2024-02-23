{pkgs, ...}: {
  environment = {
    variables.TERM = "xterm-256color";
    systemPackages = with pkgs; [
      fuse-overlayfs
    ];
    noXlibs = false;
  };
  fileSystems = {
    "/etc/ssh".neededForBoot = true;
    "/var/lib".neededForBoot = true;
  };
}
