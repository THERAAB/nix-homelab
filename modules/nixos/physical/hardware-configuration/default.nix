{
  config,
  lib,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical.hardware-configuration;
in {
  options.nix-homelab.physical.hardware-configuration = with types; {
    enable = mkEnableOption (lib.mdDoc "Filesystem and boot setup");
  };
  config = mkIf cfg.enable {
    boot = {
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
        kernelModules = [];
      };
      kernelModules = ["kvm-intel"];
      extraModulePackages = [];
    };
    fileSystems = {
      "/" = {
        device = "none";
        fsType = "tmpfs";
        options = ["size=8G" "mode=755"];
      };
      "/home/raab" = {
        device = "none";
        fsType = "tmpfs";
        options = ["size=4G" "mode=777"];
      };
      "/nix" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = ["subvol=nix" "compress=zstd" "noatime"];
      };
      "/nix/persist" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = ["subvol=persist" "compress=zstd" "noatime"];
        neededForBoot = true;
      };
      "/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
      };
    };
    swapDevices = [];
    networking.useDHCP = lib.mkDefault true;
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
