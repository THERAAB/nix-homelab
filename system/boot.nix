{ config, pkgs, ... }:
{  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Force kernel to use the right driver & use graphics controller
    kernelParams = [ "i915.force_probe=4692" "i915.enable_guc=3" ];
    # Blacklist r8169 Network driver because it sucks for RTL8125B
    # This will probably load r8168 (Realtek driver) instead
    blacklistedKernelModules = [ "r8169" ];
  };
}
