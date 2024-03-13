{
  config,
  lib,
  pkgs,
  ...
}:
with lib; 
with lib.nix-homelab; let
  cfg = config.nix-homelab.microvm.podman;
in {
  options.nix-homelab.microvm.podman = with types; {
    enable = mkEnableOption (lib.mdDoc "Podman");
  };
  config = mkIf cfg.enable {
    virtualisation.podman = {
      defaultNetwork.settings.dns_enabled = false;
      autoPrune = {
        enable = true;
        flags = ["--all"];
      };
    };
    systemd = {
      services.podman-auto-update = {
        script = ''
          ${pkgs.podman}/bin/podman auto-update
        '';
        after = ["podman.service"];
        requires = ["podman.service"];
      };
      timers.podman-auto-update = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = "true";
          Unit = "podman-auto-update.service";
        };
      };
    };
  };
}
