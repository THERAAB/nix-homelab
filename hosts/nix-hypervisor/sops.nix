{...}: let
  local-config-dir = "/run/secrets";
in {
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}/micro-media       -   -             -                   -   - "
    "d    ${local-config-dir}/micro-server      -   -             -                   -   - "
    "d    ${local-config-dir}/micro-tailscale   -   -             -                   -   - "
    "d    ${local-config-dir}/micro-utils       -   -             -                   -   - "
  ];
  sops.secrets = {
    home_assistant = {
      owner = "hass";
    };
    wireguard_mullvad = {};
    df_password = {};
    cloudflare_dns_secret = {};
    harmonia_secret = {};
    microbin_secret = {};
    mongo_init = {
      owner = "unifi";
      path = "/var/lib/microvms/micro-media/storage/var/lib/unifi/mongo_init";
    };
    mongo_secret = {
      owner = "unifi";
      path = "/var/lib/microvms/micro-media/storage/var/lib/unifi/mongo_secret";
    };
  };
}
