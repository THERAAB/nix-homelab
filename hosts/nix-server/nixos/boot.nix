{ config, pkgs, ... }:
{
  # Force kernel to use the right CPU driver & use graphics controller
  boot.kernelParams = [ "i915.force_probe=4692" "i915.enable_guc=3" ];
}
