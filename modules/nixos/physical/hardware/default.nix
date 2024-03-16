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
  };
}
