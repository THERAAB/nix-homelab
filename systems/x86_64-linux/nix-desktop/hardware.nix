{...}: {
  boot = {
    initrd.availableKernelModules = ["ahci" "usbhid"];
    kernelModules = ["kvm-amd"];
    loader.grub.extraConfig = ''
      if keystatus --shift ; then
        set timeout=-1
      else
        set timeout=0
      fi
    '';
  };
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["size=10G" "mode=755"];
    };
    "/home/raab" = {
      device = "none";
      fsType = "tmpfs";
      options = ["size=10G" "mode=777"];
    };
    "/games" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = ["subvol=games" "compress=zstd" "noatime"];
    };
  };
  networking.hostName = "nix-desktop"; # Define your hostname.
  services = {
    snapper = {
      snapshotInterval = "*:0/20";
      cleanupInterval = "2h";
      configs = {
        "persist" = {
          SUBVOLUME = "/nix/persist";
          ALLOW_USERS = ["raab"];
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          TIMELINE_MIN_AGE = 7200; # 2 hours
          TIMELINE_LIMIT_HOURLY = "10";
          TIMELINE_LIMIT_DAILY = "10";
          TIMELINE_LIMIT_WEEKLY = "4";
          TIMELINE_LIMIT_MONTHLY = "0";
          TIMELINE_LIMIT_YEARLY = "0";
        };
      };
    };
    # headsetcontrol & via udev rules
    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="fffe", ATTRS{idProduct}=="0005", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      ACTION!="add|change", GOTO="headset_end"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0ab5", TAG+="uaccess"
      LABEL="headset_end"
    '';
  };
  hardware = {
    amdgpu.initrd.enable = true;
    cpu.amd.updateMicrocode = true;
    openrazer = {
      # enable = true;
      users = ["raab"];
    };
    graphics.enable = true;
  };
  swapDevices = [];
}
