{properties, ...}: {
  networking.firewall.allowedTCPPorts = with properties.ports; [
    grafana
    prometheus
    prometheus-node
    loki
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
    scrapeConfigs = [
      {
        job_name = "node-exporter";
        static_configs = [
          {
            targets = ["127.0.0.1:${toString properties.ports.prometheus-node}"];
          }
        ];
      }
    ];
  };
  services.loki = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = properties.ports.loki;
      };
    };
  };
}
