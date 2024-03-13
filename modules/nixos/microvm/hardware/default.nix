{
  config,
  lib,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.microvm.hardware;
in {
  options.nix-homelab.microvm.hardware = with types; {
    enable = mkEnableOption (lib.mdDoc "System");
    hostName = mkOption {
      type = str;
    };
  };
  config = mkIf cfg.enable {
    environment.etc."machine-id" = {
      mode = "0644";
      text = properties.network.${cfg.hostName}.machine-id + "\n";
    };
    fileSystems = {
      "/etc/ssh".neededForBoot = true;
      "/var/lib".neededForBoot = true;
      "/var/log/journal".neededForBoot = true;
    };
  };
}
