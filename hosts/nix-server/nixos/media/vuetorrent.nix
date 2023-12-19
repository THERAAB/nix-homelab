{...}: let
  media = import ./media.properties.nix;
  uid = 9990;
  port = 8112;
  app-name = "vuetorrent";
  local-config-dir = "/var/lib/${app-name}/";
  network = import ../../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "VueTorrent";
      url = "https://${app-name}.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
  ];
  services.olivetin.settings.actions = [
    {
      title = "Restart Vuetorrent";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /var/lib/olivetin/scripts/commands.sh -p ${app-name}";
      timeout = 20;
    }
  ];
  users = {
    users."${app-name}" = {
      group = "media";
      uid = uid;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}/wireguard             -       -               -       -   -                               "
    "r    ${local-config-dir}/wireguard/wg0.conf    -       -               -       -   -                               "
    "C    ${local-config-dir}/wireguard/wg0.conf    -       -               -       -   /run/secrets/wireguard_mullvad  "
    "Z    ${local-config-dir}                       740     ${app-name}     -       -   -                               "
  ];
  services.caddy.virtualHosts."${app-name}.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "ghcr.io/hotio/qbittorrent";
    volumes = [
      "${local-config-dir}:/config"
      "${media.dir.downloads}:/app/qBittorrent/downloads"
    ];
    ports = ["${toString port}:8080" "8118:8118"];
    environment = {
      PUID = "${toString uid}";
      PGID = "${toString media.gid}";
      UMASK = "022";
      TZ = "America/New_York";
      VPN_ENABLED = "true";
      VPN_LAN_NETWORK = "${network.nix-desktop.local.ip},${network.ap.subnet}";
      VPN_CONF = "wg0";
      VPN_ADDITIONAL_PORTS = "";
      VPN_IP_CHECK_DELAY = "5";
      VPN_IP_CHECK_EXIT = "true";
      PRIVOXY_ENABLED = "true";
    };
    extraOptions = [
      "--privileged"
      "--cap-add=NET_ADMIN"
      ''--sysctl="net.ipv4.conf.all.src_valid_mark=1"''
      ''--sysctl="net.ipv6.conf.all.disable_ipv6=1"''
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
