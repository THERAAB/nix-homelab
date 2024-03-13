{inputs,...}: let
  uid = 9990;
  port = 8112;
  app-name = "vuetorrent";
  local-config-dir = "/var/lib/${app-name}";
  network = import (inputs.self + /assets/properties/network.properties.nix);
  media = import (inputs.self + /assets/properties/media.properties.nix);
in {
  users = {
    users."${app-name}" = {
      uid = uid;
      group = media.group.name;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}/wireguard             -       -               -                   -   -                               "
    "r    ${local-config-dir}/wireguard/wg0.conf    -       -               -                   -   -                               "
    "C    ${local-config-dir}/wireguard/wg0.conf    -       -               -                   -   /run/secrets/wireguard_mullvad  "
    "Z    ${local-config-dir}                       -       ${app-name}     ${media.group.name} -   -                               "
    "Z    ${local-config-dir}/wireguard/wg0.conf    700     -               -                   -   -                               "
  ];
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "ghcr.io/hotio/qbittorrent:latest";
    volumes = [
      "${local-config-dir}:/config"
      "${media.dir.downloads}:/app/qBittorrent/downloads"
    ];
    ports = ["${toString port}:8080" "8118:8118"];
    environment = {
      PUID = "${toString uid}";
      PGID = "${toString media.group.id}";
      UMASK = "022";
      TZ = "America/New_York";
      VPN_ENABLED = "true";
      VPN_LAN_NETWORK = "${network.nix-desktop.local.ip},${network.ap.subnet},${network.micro-media.local.ip},${network.micro-tailscale.local.ip},${network.micro-download.local.ip}";
      VPN_CONF = "wg0";
      VPN_ADDITIONAL_PORTS = "";
      VPN_IP_CHECK_DELAY = "5";
      VPN_IP_CHECK_EXIT = "true";
      PRIVOXY_ENABLED = "true";
    };
    extraOptions = [
      "--cap-add=NET_ADMIN"
      ''--sysctl="net.ipv4.conf.all.src_valid_mark=1"''
      ''--sysctl="net.ipv6.conf.all.disable_ipv6=1"''
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
