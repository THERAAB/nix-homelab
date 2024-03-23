{properties, ...}: {
  networking.firewall.allowedTCPPorts = with properties.ports; [
    grafana
    prometheus
    prometheus-node
    loki
    promtail
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
    enable = true; #TODO
    configuration = {
      auth_enabled = false;
      server.http_listen_port = properties.ports.loki;
      ingester = {
        lifecycler = {
          address = "0.0.0.0";
          ring = {
            kvstore.store = "inmemory";
            replication_factor = 1;
          };
          final_sleep = "0s";
        };
        chunk_idle_period = "1h";
        max_chunk_age = "1h";
        chunk_target_size = 1048576;
        chunk_retain_period = "30s";
        max_transfer_retries = 0;
      };
      schema_config = {
        configs = [
          {
            from = "2022-06-06";
            store = "boltdb-shipper";
            object_store = "filesystem";
            schema = "v11";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };
      storage_config = {
        boltdb_shipper = {
          active_index_directory = "/var/lib/loki/boltdb-shipper-active";
          cache_location = "/var/lib/loki/boltdb-shipper-cache";
          cache_ttl = "24h";
          shared_store = "filesystem";
        };
        filesystem.directory = "/var/lib/loki/chunks";
      };
      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };
      chunk_store_config.max_look_back_period = "0s";
      table_manager = {
        retention_deletes_enabled = false;
        retention_period = "0s";
      };
      compactor = {
        working_directory = "/var/lib/loki";
        shared_store = "filesystem";
        compactor_ring.kvstore.store = "inmemory";
      };
    };
  };
  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = properties.ports.promtail;
        grpc_listen_port = 0;
      };
      positions.filename = "/tmp/positions.yaml";
      clients = [
        {
          url = "http://127.0.0.1:${toString properties.ports.loki}/loki/api/v1/push";
        }
      ];
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "node-exporter";
            };
          };
          relabel_configs = [
            {
              source_labels = ["__journal__systemd_unit"];
              target_label = "unit";
            }
          ];
        }
      ];
    };
  };
}
