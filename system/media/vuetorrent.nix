{ config, pkgs, ... }:
let
  media = (import ./media.properties.nix);
  uid = 9990;
  port = 8112;
  app-name = "vuetorrent";
  local-config-dir = media.dir.config + "/${app-name}/";
  network = (import ../network.properties.nix);
in
{
  users = {
    users."${app-name}" = {
      group = "media";
      uid = uid;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}/wireguard             -       -               -       -   -                               "
    "C    ${local-config-dir}/wireguard/wg0.conf    -       -               -       -   /run/secrets/wireguard_mullvad  "
    "Z    ${local-config-dir}                       740     ${app-name}     media   -   -                               "
  ];
  services.caddy.virtualHosts = {
    "http://${app-name}.server.box".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://${app-name}.server.tail".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "cr.hotio.dev/hotio/qbittorrent";
    volumes = [
      "${local-config-dir}:/config"
      "${media.dir.downloads}:/app/qBittorrent/downloads"
    ];
    ports = [ "${toString port}:8080" "8118:8118" ];
    environment = {
      PUID="${toString uid}";
      PGID="${toString media.gid}";
      UMASK="022";
      TZ="America/New_York";
      VPN_ENABLED="true";
      VPN_LAN_NETWORK="${network.desktop.subnet},${network.nix-homelab.subnet}";
      VPN_CONF="wg0";
      VPN_ADDITIONAL_PORTS="";
      VPN_IP_CHECK_DELAY="5";
      VPN_IP_CHECK_EXIT="true";
      PRIVOXY_ENABLED="true";
    };
    extraOptions = [
      "--cap-add=NET_ADMIN"
      ''--sysctl="net.ipv4.conf.all.src_valid_mark=1"''
      ''--sysctl="net.ipv6.conf.all.disable_ipv6=0"''
    ];
  };
}