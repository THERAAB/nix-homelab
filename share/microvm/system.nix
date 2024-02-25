{pkgs, ...}: {
  environment = {
    variables.TERM = "xterm-256color";
    noXlibs = false;
    systemPackages = with pkgs; [
      fuse-overlayfs
    ];
  };
  fileSystems = {
    "/etc/ssh".neededForBoot = true;
    "/var/lib".neededForBoot = true;
  };
}
