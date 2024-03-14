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
    enable = mkEnableOption (lib.mdDoc "System");
  };
  config = mkIf cfg.enable {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      # Power Management stuff
      kernel.sysctl = {
        "vm.dirty_writeback_centisecs" = 6000;
        "vm.laptop_mode" = 5;
      };
    };
    services = {
      fstrim.enable = true;
      fwupd.enable = true;
    };
    powerManagement = {
      enable = true;
      # Sata power management
      scsiLinkPolicy = "med_power_with_dipm";
      powertop.enable = true;
    };
    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
    };
    networking.firewall.trustedInterfaces = ["tailscale0"];
  };
}
