{properties, ...}: {
  networking.firewall.allowedTCPPorts = [
    properties.ports.grafana
    properties.ports.prometheus
    properties.ports.prometheus-node
  ];
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "grafana.${properties.network.domain}";
      http_port = properties.ports.grafana;
      http_addr = "0.0.0.0";
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
