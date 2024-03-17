{properties, ...}: {
  networking.firewall.allowedTCPPorts = [2344 9001 9002];
  services.grafana = {
    enable = true;
    domain = "grafana.${properties.network.domain}";
    settings.server = {
      http_port = properties.ports.grafana;
      http_addr = "127.0.0.1";
    };
  };
  services.prometheus = {
    enable = true;
    port = properties.ports.prometheus;
    exporters.node = {
      enable = true;
      enabledCollectors = ["systemd"];
      port = properties.ports.prometheus-node;
    };
  };
}
