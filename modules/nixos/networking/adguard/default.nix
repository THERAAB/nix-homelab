{
  config,
  properties,
  lib,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.networking.adguard;
  port = properties.ports.adguard;
  filter-dir = "https://adguardteam.github.io/HostlistsRegistry/assets";
in {
  options.nix-homelab.networking.adguard = with types; {
    enable = mkEnableOption (lib.mdDoc "Adguard setup");
  };
  config = mkIf cfg.enable {
    networking.firewall = {
      allowedUDPPorts = [properties.ports.dns];
      allowedTCPPorts = [port];
    };
    services.adguardhome = {
      port = port;
      mutableSettings = false;
      enable = true;
      settings = {
        users = [
          {
            name = "raab";
            password = "$2a$10$4gtwC3j0OycMT2aMfwEbUepE.e6sFFhJq2JLuVLS1zy6iL8ebax3K";
          }
        ];
        theme = "auto";
        dns = {
          ratelimit = 0;
          port = properties.ports.dns;
          upstream_dns = ["${properties.network.pfSense.local.ip}"];
          protection_enabled = true;
          blocked_hosts = ["version.bind" "id.server" "hostname.bind"];
          trusted_proxies = ["127.0.0.0/8" "::1/128"];
          cache_size = 4194304;
          bootstrap_dns = ["9.9.9.0" "149.112.112.10" "2620:fe::10" "2620:fe::fe:10"];
        };
        filters = [
          {
            enabled = true;
            url = "${filter-dir}/filter_1.txt";
            name = "AdGuard DNS filter";
            id = 1;
          }
          {
            enabled = true;
            url = "${filter-dir}/filter_2.txt";
            name = "AdAway Default Blocklist";
            id = 2;
          }
          {
            enabled = true;
            url = "${filter-dir}/filter_5.txt";
            name = "OISD Blocklist Basic";
            id = 3;
          }
          {
            enabled = true;
            url = "${filter-dir}/filter_4.txt";
            name = "Dan Pollock's List";
            id = 4;
          }
          {
            enabled = true;
            url = "${filter-dir}/filter_6.txt";
            name = "Dandelion Sprout's Game Console Adblock List";
            id = 5;
          }
          {
            enabled = true;
            url = "${filter-dir}/filter_7.txt";
            name = "Perflyst and Dandelion Sprout's Smart-TV Blocklist";
            id = 6;
          }
          {
            enabled = true;
            url = "${filter-dir}/filter_12.txt";
            name = "Dandelion Sprout's Anti-Malware List";
            id = 7;
          }
          {
            enabled = true;
            url = "${filter-dir}/filter_8.txt";
            name = "NoCoin Filter List";
            id = 8;
          }
          {
            enabled = true;
            url = "${filter-dir}/filter_3.txt";
            name = "Peter Lowe's Blocklist";
            id = 9;
          }
          {
            enabled = true;
            url = "${filter-dir}/filter_10.txt";
            name = "Scam Blocklist by DurableNapkin";
            id = 10;
          }
        ];
      };
    };
  };
}
