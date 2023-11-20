{pkgs, ...}: {
  systemd.tmpfiles.rules = [
    "R  /var/lib/hass/custom_components/smartlife   -       -       -       -   -                                                        "
    "L  /var/lib/hass/custom_components/smartlife   770     hass    hass    -   ${pkgs.localtuya}/custom_components/localtuya            "
  ];
  services.home-assistant = {
    config.automation = [
    ];
  };
}
