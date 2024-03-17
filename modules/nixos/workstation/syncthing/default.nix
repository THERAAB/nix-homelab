{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.syncthing;
in {
  options.nix-homelab.workstation.syncthing = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup syncthing");
  };
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      relay.enable = false;
      openDefaultPorts = true;
      overrideDevices = false;
      overrideFolders = false;
      settings = {
        options.urAccepted = -1;
        devices = {
          nix-server = {
            id = "W33BOU2-KH5UGR6-MLWF3FP-EO4D4MT-QJZHZ44-XGSW54C-JXWMZFB-W5DKMQU";
            addresses = ["tcp://${properties.network.nix-hypervisor.local.ip}:22000" "tcp://${properties.network.nix-hypervisor.tailscale.ip}:22000"];
            introducer = true;
          };
        };
      };
    };
  };
}
