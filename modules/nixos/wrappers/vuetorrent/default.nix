{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.vuetorrent;
  uid = 9990;
  port = properties.ports.vuetorrent;
  app-name = "vuetorrent";
  local-config-dir = "/var/lib/${app-name}";
in {
  options.nix-homelab.wrappers.vuetorrent = with types; {
    enable = mkEnableOption (lib.mdDoc "Vuetorrent");
  };
  config = mkIf cfg.enable {
    users = {
      users."${app-name}" = {
        uid = uid;
        group = properties.media.group.name;
        isSystemUser = true;
      };
    };
    systemd.tmpfiles.rules = [
      "d    ${local-config-dir}/wireguard             -       -               -                               -   -                               "
      "r    ${local-config-dir}/wireguard/wg0.conf    -       -               -                               -   -                               "
      "C    ${local-config-dir}/wireguard/wg0.conf    -       -               -                               -   /run/secrets/wireguard_mullvad  "
      "Z    ${local-config-dir}                       -       ${app-name}     ${properties.media.group.name}  -   -                               "
      "Z    ${local-config-dir}/wireguard/wg0.conf    700     -               -                               -   -                               "
    ];
    virtualisation.oci-containers.containers."${app-name}" = {
      autoStart = true;
      image = "ghcr.io/hotio/qbittorrent:legacy";
      volumes = [
        "${local-config-dir}:/config"
        "${properties.media.dir.downloads}:/app/qBittorrent/downloads"
      ];
      ports = ["${toString port}:8080" "8118:8118"];
      environment = {
        PUID = "${toString uid}";
        PGID = "${toString properties.media.group.id}";
        UMASK = "022";
        TZ = "America/New_York";
        VPN_ENABLED = "true";
        VPN_LAN_NETWORK = "${properties.network.nix-desktop.local.ip},${properties.network.ap.subnet},${properties.network.micro-media.local.ip},${properties.network.micro-tailscale.local.ip},${properties.network.micro-download.local.ip}";
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
  };
}
