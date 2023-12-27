{...}: let
  port = 19999;
in {
  networking.firewall.allowedTCPPorts = [port];
  services.netdata = {
    enable = true;
    configText = ''
      [global]
        update every = 5
      [ml]
        enabled = no
      [logs]
        debug log = none
        error log = none
        access log = none
    '';
  };
}
