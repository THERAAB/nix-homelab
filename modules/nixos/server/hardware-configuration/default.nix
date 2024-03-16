{
  config,
  lib,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.server.hardware-configuration;
in {
  options.nix-homelab.server.hardware-configuration = with types; {
    enable = mkEnableOption (lib.mdDoc "Filesystem and boot setup");
  };
  config = mkIf cfg.enable {
    boot = {
      initrd = {
        availableKernelModules = ["ahci" "usbhid"];
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
    };
    swapDevices = [];
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
