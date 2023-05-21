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
  };
}
