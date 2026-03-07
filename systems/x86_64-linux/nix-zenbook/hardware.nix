{
  lib,
  pkgs,
  ...
}: {
  boot = {
    initrd.availableKernelModules = ["thunderbolt" "vmd" "sdhci_pci"];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    loader.grub.extraConfig = ''
      acpi /ssdt-csc3551.aml
      set timeout=1
    '';
    # Power Management stuff
    kernel.sysctl = {
      "vm.dirty_writeback_centisecs" = 6000;
      "vm.laptop_mode" = 5;
    };
    kernelParams = [
      "kernel.nmi_watchdog=0"
      "nvme.noacpi=1" # Sleep performance
      "acpi.no_ec_wakeup=1" # Sleep performance
      "resume_offset=11609344"
      "acpi_sleep=s4_nohwsig" # Fix unreliable resume from hibernate
    ];
    extraModprobeConfig = ''
      options iwlwifi power_save=1
      options iwlmvm power_scheme=3
      options iwlwifi uapsd_disable=0
      options i915 enable_guc=3
      options i915 enable_fbc=1
      options snd_hda_intel power_save=1
    '';
    resumeDevice = "/dev/disk/by-label/nixos";
  };
  fileSystems = {
    "/home/raab" = {
      device = "none";
      fsType = "tmpfs";
      options = ["size=2G" "mode=777"];
      neededForBoot = true;
    };
    "/swap" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = ["subvol=swap" "compress=no" "noatime"];
    };
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8 * 1024;
    }
  ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware = {
    cpu.intel.updateMicrocode = true;
    bluetooth.settings = {
      General = {
        Experimental = true;
      };
    };
    # Intel hardware acceleration
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
  };
  environment.systemPackages = with pkgs; [
    gnome-power-manager
  ];
  networking.hostName = "nix-zenbook";
  powerManagement = {
    enable = true;
    scsiLinkPolicy = "med_power_with_dipm";
    powertop.enable = true;
  };
  systemd.services.post-boot = {
    description = "Post-boot Actions";
    wantedBy = ["multi-user.target"];
    restartIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      echo 80 > /sys/class/power_supply/BAT?/charge_control_end_threshold
    '';
  };
  services = {
    thermald.enable = true;
    logind.settings.Login.HandlelidSwitch = "suspend-then-hibernate";
    # Disable ELAN Fingerprint reader
    udev.extraRules = ''ATTRS{idVendor}=="04f3", ATTRS{idProduct}=="0c6e", SUBSYSTEM=="usb", ATTR{authorized}="0"'';
  };
  systemd = {
    sleep.extraConfig = ''
      HibernateDelaySec=8h
      HibernateMode=shutdown
    '';
    services = {
      battery-charge-threshold = {
        wantedBy = ["local-fs.target" "suspend.target"];
        after = ["local-fs.target" "suspend.target"];
        description = "Set the battery charge threshold%";
        startLimitBurst = 5;
        startLimitIntervalSec = 1;
        serviceConfig = {
          Type = "oneshot";
          Restart = "on-failure";
          ExecStart = "${pkgs.runtimeShell} -c 'echo 80 > /sys/class/power_supply/BAT?/charge_control_end_threshold'";
        };
      };
    };
  };
}
