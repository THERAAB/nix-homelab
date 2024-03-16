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
    };
    powerManagement = {
      enable = true;
      # Sata power management
      scsiLinkPolicy = "med_power_with_dipm";
      powertop.enable = true;
    };
    services.tailscale.extraUpFlags = ["--ssh"];
  };
}
