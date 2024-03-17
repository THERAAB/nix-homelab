{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical.hardware;
in {
  options.nix-homelab.physical.hardware = with types; {
    enable = mkEnableOption (lib.mdDoc "Physical system hardware");
  };
  config = mkIf cfg.enable {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      loader.efi.canTouchEfiVariables = true;
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];
        kernelModules = [];
      };
      extraModulePackages = [];
    };
    services = {
      fstrim.enable = true;
      fwupd.enable = true;
    };
    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
    };
    networking.firewall.trustedInterfaces = ["tailscale0"];
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
