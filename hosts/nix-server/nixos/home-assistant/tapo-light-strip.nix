{pkgs, ...}: {
  systemd.tmpfiles.rules = [
    "R  /var/lib/hass/custom_components/tapo   -       -       -       -   -                                                        "
    "L  /var/lib/hass/custom_components/tapo   770     hass    hass    -   ${pkgs.home-assistant-tapo-p100}/custom_components/tapo  "
  ];
}
