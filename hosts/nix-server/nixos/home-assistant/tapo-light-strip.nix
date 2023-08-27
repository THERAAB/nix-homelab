{pkgs, ...}: {
  systemd.tmpfiles.rules = [
    "R  /var/lib/hass/custom_components/tapo   -       -       -       -   -                                                        "
    "L  /var/lib/hass/custom_components/tapo   770     hass    hass    -   ${pkgs.home-assistant-tapo-p100}/custom_components/tapo  "
  ];
  services.home-assistant = {
    extraPackages = python310Packages:
      with python310Packages; [
        (
          buildPythonPackage rec {
            pname = "plugp100";
            version = "3.9.0";
            src = fetchPypi {
              inherit version pname;
              hash = "sha256-wYL3CGh4Q2TBggI2l96VK+yhjDsqgNSSF6sv4ASAIXE=";
            };

            propagatedBuildInputs = [
              certifi
              cryptography
              jsons
              requests
              aiohttp
              semantic-version
            ];
          }
        )
      ];
    config.automation = [
      {
        alias = "Turn on Kitchen Cabinet LEDs when Motion Detected";
        trigger = {
          platform = "state";
          entity_id = "binary_sensor.lumi_lumi_motion_ac02_motion";
          from = "off";
          to = "on";
        };
        condition = {
          condition = "numeric_state";
          entity_id = "sensor.lumi_lumi_motion_ac02_illuminance";
          below = "10";
        };
        action = {
          service = "light.turn_on";
          data = {
            brightness_pct = 15;
            color_temp = 250;
          };
          target = {
            entity_id = "light.kitchen_over_cabinet_lights";
          };
        };
      }
    ];
  };
}
