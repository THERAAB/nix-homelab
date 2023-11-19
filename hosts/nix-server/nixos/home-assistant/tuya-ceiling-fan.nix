{pkgs, ...}: {
  systemd.tmpfiles.rules = [
    "R  /var/lib/hass/custom_components/smartlife   -       -       -       -   -                                                        "
    "L  /var/lib/hass/custom_components/smartlife   770     hass    hass    -   ${pkgs.tuya-smart-life}/custom_components/smartlife      "
  ];
  services.home-assistant = {
    config.automation = [
    ];
  };
}
