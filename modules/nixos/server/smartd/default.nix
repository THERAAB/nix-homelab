{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.server.smartd;
  log-dir = "/var/log/smartd/";
in {
  options.nix-homelab.server.smartd = with types; {
    enable = mkEnableOption (lib.mdDoc "SMART monitoring");
  };
  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d    ${log-dir}  -    - -        -   - "
      "Z    ${log-dir}  770  - netdata  -   - "
    ];
    services.smartd = {
      enable = true;
      extraOptions = [
        "-A"
        "${log-dir}"
        "--interval=3600"
      ];
    };
  };
}
