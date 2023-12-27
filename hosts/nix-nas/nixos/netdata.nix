{...}: let
  port = 19999;
  app-name = "netdata";
  network = import ../../../share/network.properties.nix;
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
      [registry]
        enabled = no
        registry to announce = https://${app-name}.${network.domain}/
        enable cookies SameSite and Secure = no
    '';
  };
}
