{...}: {
  sops.secrets = {
    home_assistant = {
      owner = "hass";
      path = "/var/lib/hass/secrets.yaml";
    };
    wireguard_mullvad = {
      owner = "vuetorrent";
    };
    df_password = {};
    authelia_jwt_secret.owner = "authelia-pumpkin-rodeo";
    authelia_storage_secret.owner = "authelia-pumpkin-rodeo";
    cloudflare_secret.owner = "cloudflared";
    mongo_init.owner = "unifi";
    mongo_secret.owner = "unifi";
  };
}
