{ config, pkgs, lib, fetchFromGitHub, kernel, ... }:
{  
  boot = {
    kernelPackages = pkgs.linuxPackages_5_9;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Force kernel to use the right CPU driver & use graphics controller
    kernelParams = [ "i915.force_probe=4692" "i915.enable_guc=3" ];
    # Adding patched r8125 kernel module for ethernet
    extraModulePackages = [
      # pkgs.r8125
    ];
  };
}
