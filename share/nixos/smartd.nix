{...}: let
  log-dir = "/var/log/smartd";
in {
  systemd.tmpfiles.rules = [
    "d    ${log-dir}  -    - -  -   - "
    "Z    ${log-dir}  755  - -  -   - "
  ];
  services.smartd = {
    enable = true;
    extraOptions = [
      "-A"
      "/var/log/smartd/"
      "--interval=3600"
    ];
  };
}
