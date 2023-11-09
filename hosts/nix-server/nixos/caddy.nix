{...}: {
  services.caddy = {
    enable = true;
    globalConfig = ''
      acme_dns
    '';
  };
}
