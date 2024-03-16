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
        availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];
        kernelModules = [];
      };
      extraModulePackages = [];
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
      "/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
      };
    };
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    networking.useDHCP = lib.mkDefault true;
  };
}
