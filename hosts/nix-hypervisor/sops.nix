{...}: let
  local-config-dir = "/run/secrets";
in {
  systemd.tmpfiles.rules = [
    # Micro-Media
    "d    ${local-config-dir}/micro-media                             -   -   -   -   -                                           "
    "R    ${local-config-dir}/micro-media/wireguard_mullvad           -   -   -   -   -                                           "
    "C    ${local-config-dir}/micro-media/wireguard_mullvad           -   -   -   -   ${local-config-dir}/wireguard_mullvad       "
    # Micro-Server
    "d    ${local-config-dir}/micro-server                            -   -   -   -   -                                           "
    "R    ${local-config-dir}/micro-server/home_assistant             -   -   -   -   -                                           "
    "C    ${local-config-dir}/micro-server/home_assistant             -   -   -   -   ${local-config-dir}/home_assistant          "
    "R    ${local-config-dir}/micro-server/df_password                -   -   -   -   -                                           "
    "C    ${local-config-dir}/micro-server/df_password                -   -   -   -   ${local-config-dir}/df_password             "
    # Micro-Tailscale
    "d    ${local-config-dir}/micro-tailscale                         -   -   -   -   -                                           "
    "R    ${local-config-dir}/micro-tailscale/cloudflare_dns_secret   -   -   -   -   -                                           "
    "C    ${local-config-dir}/micro-tailscale/cloudflare_dns_secret   -   -   -   -   ${local-config-dir}/cloudflare_dns_secret   "
    # Micro-Utils
    "d    ${local-config-dir}/micro-utils                             -   -   -   -   -                                           "
    "R    ${local-config-dir}/micro-utils/gotify_gatus_token          -   -   -   -   -                                           "
    "C    ${local-config-dir}/micro-utils/gotify_gatus_token          -   -   -   -   ${local-config-dir}/gotify_gatus_token      "
    "R    ${local-config-dir}/micro-utils/mongo_secret                -   -   -   -   -                                           "
    "C    ${local-config-dir}/micro-utils/mongo_secret                -   -   -   -   ${local-config-dir}/mongo_secret            "
    "R    ${local-config-dir}/micro-utils/mongo_init                  -   -   -   -   -                                           "
    "C    ${local-config-dir}/micro-utils/mongo_init                  -   -   -   -   ${local-config-dir}/mongo_init              "
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
    };
    mongo_secret = {
      owner = "unifi";
    };
  };
}
