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
    fileSystems = {
      "/sync" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = ["subvol=sync" "compress=zstd" "noatime"];
      };
    };
  };
}
