{...}: let
  log-dir = "/var/log/smartd/";
in {
  systemd.tmpfiles.rules = [
    "d    ${log-dir}  -    - -        -   - "
    "Z    ${log-dir}  740  - netdata  -   - "
  ];
  services.smartd = {
    enable = true;
    extraOptions = [
      "-A"
      "${log-dir}"
      "--interval=3600"
    ];
  };
}