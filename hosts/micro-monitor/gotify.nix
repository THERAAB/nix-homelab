{...}: let
  port = 8238;
  app-name = "gotify";
in {
  networking.firewall.allowedTCPPorts = [port];
  services.${app-name} = {
    enable = true;
    port = port;
  };
  systemd.services.gotify-server.environment = {
    GOTIFY_SERVER_SSL_ENABLED = "false";
    GOTIFY_SERVER_SSL_REDIRECTTOHTTPS = "false";
    GOTIFY_SERVER_SSL_LETSENCRYPT_ENABLED = "false";
  };
}
