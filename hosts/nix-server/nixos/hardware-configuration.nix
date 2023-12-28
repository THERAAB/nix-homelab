{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  # Force kernel to use the right CPU driver & use graphics controller
  boot.kernelParams = ["i915.force_probe=4692" "i915.enable_guc=3"];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["size=10G" "mode=755"];
  };
  fileSystems."/home/raab" = {
    device = "none";
    fsType = "tmpfs";
    options = ["size=4G" "mode=777"];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
  };
  fileSystems."/nix/persist" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = ["subvol=persist" "compress=zstd" "noatime"];
    neededForBoot = true;
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
