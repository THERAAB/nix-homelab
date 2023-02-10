{ config, pkgs, ... }:
{  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Force kernel to use the right driver & use graphics controller
    kernelParams = [ "i915.force_probe=4692" "i915.enable_guc=3" ];
  };

  # Install r8168 driver (RealTek proprietary) for network controller
  # environment.systemPackages = [ pkgs.linuxKernel.packages.linux_6_1.r8168 ];
  # and blacklist kernel module driver
  # boot.blacklistedKernelModules = [ "r8169" ];
}
