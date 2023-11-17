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
    authelia_jwt_secret = {};
    authelia_storage_secret = {};
    cloudflare_secret = {
      owner = "cloudflared";
      path = "/var/lib/secrets/cloudflare.secret";
    };
    mongo_init = {
      owner = "unifi";
      path = "/nix/persist/unifi/init-mongo.js";
    };
    mongo_secret = {
      owner = "unifi";
      path = "/nix/persist/unifi/env.secret";
    };
  };
}
