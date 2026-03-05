{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.server.hardware;
in {
  options.nix-homelab.server.hardware = with types; {
    enable = mkEnableOption (lib.mdDoc "Physical system hardware");
  };
  config = mkIf cfg.enable {
    boot = {
      loader.systemd-boot.enable = true;
      # Power Management stuff
      kernel.sysctl = {
        "vm.dirty_writeback_centisecs" = 6000;
        "vm.laptop_mode" = 5;
      };
      initrd = {
        availableKernelModules = ["ahci" "usbhid"];
      };
      kernelModules = ["kvm-intel"];
      extraModulePackages = [];
    };
    powerManagement = {
      enable = true;
      # Sata power management
      powertop.enable = true;
      cpuFreqGovernor = lib.mkDefault "powersave";
    };
    services.tailscale.extraUpFlags = ["--ssh"];
    fileSystems = {
      "/home/raab" = {
        device = "none";
        fsType = "tmpfs";
        options = ["size=4G" "mode=777"];
        neededForBoot = true;
      };
    };
    swapDevices = [];
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
