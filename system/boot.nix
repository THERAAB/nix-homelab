{ config, pkgs, ... }:
{  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Force kernel to use the right CPU driver & use graphics controller
    kernelParams = [ "i915.force_probe=4692" "i915.enable_guc=3" ];
    extraModulePackages = [ pkgs.r8125 ];
  };
}
