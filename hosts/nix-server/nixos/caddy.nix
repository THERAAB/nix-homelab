{...}: {
  services.caddy = {
    enable = true;
    globalConfig = ''
      local_certs
    '';
  };
}
