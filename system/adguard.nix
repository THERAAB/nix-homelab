{ config, pkgs, ... }:
let
  port = 3000;
  network = (import ./network.properties.nix);
in
{
  imports = [ ../modules/nixos/olivetin ];
  services.olivetin.settings.actions = [
    {
      title = "Restart AdGuard";
      icon = ''<img src = "customIcons/adguard.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -s adguardhome";
      timeout = 20;
    }
  ];
  services.caddy.virtualHosts = {
    "http://adguard.server.box".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://adguard.server.tail".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  networking.firewall.allowedTCPPorts = [ port ];
  services.adguardhome = {
    mutableSettings = false;
    enable = true;
    settings = {
      bind_host = "0.0.0.0";
      bind_port = port;
      users = [{
        name = "raab";
        password = "$2a$10$4gtwC3j0OycMT2aMfwEbUepE.e6sFFhJq2JLuVLS1zy6iL8ebax3K";
      }];
      theme = "auto";
      dns = {
        ratelimit = 0;
        bind_hosts = [ "0.0.0.0" ];
        port = 53;
        upstream_dns = [ "${network.pfSense.local.ip}" ];
        protection_enabled = true;
        blocked_hosts = [ "version.bind" "id.server" "hostname.bind" ];
        trusted_proxies = [ "127.0.0.0/8" "::1/128" ];
        cache_size = 4194304;
        bootstrap_dns = [ "9.9.9.0" "149.112.112.10" "2620:fe::10" "2620:fe::fe:10" ];
        rewrites = [
          {
            domain = "server.box";
            answer = "${network.nix-homelab.local.ip}";
          }
          {
            domain = "*.server.box";
            answer = "${network.nix-homelab.local.ip}";
          }
          {
            domain = "server.tail";
            answer = "${network.nix-homelab.tailscale.ip}";
          }
          {
            domain = "*.server.tail";
            answer = "${network.nix-homelab.tailscale.ip}";
          }
        ];
      };
      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          name = "AdGuard DNS filter";
          id = 1;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
          name = "AdAway Default Blocklist";
          id = 2;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_5.txt";
          name = "OISD Blocklist Basic";
          id = 3;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_4.txt";
          name = "Dan Pollock's List";
          id = 4;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_6.txt";
          name = "Dandelion Sprout's Game Console Adblock List";
          id = 5;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_7.txt";
          name = "Perflyst and Dandelion Sprout's Smart-TV Blocklist";
          id = 6;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_12.txt";
          name = "Dandelion Sprout's Anti-Malware List";
          id = 7;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_8.txt";
          name = "NoCoin Filter List";
          id = 8;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_3.txt";
          name = "Peter Lowe's Blocklist";
          id = 9;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_10.txt";
          name = "Scam Blocklist by DurableNapkin";
          id = 10;
        }
      ];
    };
  };
}