{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.hardware-configuration;
in {
  options.nix-homelab.workstation.hardware-configuration = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup hardware-configuration");
  };
  config = mkIf cfg.enable {
    boot = {
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];
        kernelModules = [];
      };
    };
    fileSystems = {
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
      "/sync" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = ["subvol=sync" "compress=zstd" "noatime"];
      };
      "/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
      };
    };
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    networking.useDHCP = lib.mkDefault true;
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
