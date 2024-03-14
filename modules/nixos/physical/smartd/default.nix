{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical.smartd;
  log-dir = "/var/log/smartd/";
in {
  options.nix-homelab.physical.smartd = with types; {
    enable = mkEnableOption (lib.mdDoc "System");
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
