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
    kernelModules = [ "r8168" ];
  };
  # /sys/class/net/enp3s0
  # sudo udevadm test-builtin net_id /sys/class/net/enp3s0 > /dev/null
  # enp3s0: MAC address identifier: hw_addr=d8:5e:d3:96:1c:ac → xd85ed3961cac
  # 03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8125 2.5GbE Controller (rev 05)
  # SUBSYSTEM=="net", ACTION=="add", ATTR{address}="d8:5e:d3:96:1c:ac",
  # SUBSYSTEM=="net", ACTION=="add", KERNELS=="03:00.0"
  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}="d8:5e:d3:96:1c:ac", DRIVERS=="r8168"
  '';
}
