{ config, pkgs, ... }:
{  
  boot = {
    kernelPackages = pkgs.linuxPackages_5_15;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Force kernel to use the right CPU driver & use graphics controller
    kernelParams = [ "i915.force_probe=4692" "i915.enable_guc=3" ];
    # Power Management stuff
    kernel.sysctl = {
      "vm.dirty_writeback_centisecs" = 6000;
      "vm.laptop_mode" = 5;
    };
    # Adding r8168 kernel module for ethernet
    extraModulePackages = with config.boot.kernelPackages; [ r8168 ];
    initrd.availableKernelModules = [ "r8168" ];
    initrd.kernelModules = [ "r8168" ];
  };
}
