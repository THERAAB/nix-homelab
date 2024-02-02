{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["size=8G" "mode=755"];
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
