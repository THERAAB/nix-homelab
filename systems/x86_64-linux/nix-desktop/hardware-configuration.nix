{
  config,
  lib,
  ...
}: {
  boot = {
    initrd.availableKernelModules = ["ahci" "usbhid"];
    kernelModules = ["kvm-amd"];
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
  swapDevices = [];
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
