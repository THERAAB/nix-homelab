{pkgs, ...}: {
  services.home-assistant = {
    customComponents = [
      pkgs.home-assistant-tapo-p100
    ];
    extraPackages = pythonPackages:
      with pythonPackages; [
        (
          buildPythonPackage rec {
            pname = "plugp100";
            version = "4.0.3";
            src = fetchPypi {
              inherit version pname;
              hash = "sha256-zeK1ij3F6Ot+EBrXvHzoyGgJFEesTrzjksQP9N4Y4IM=";
            };
            propagatedBuildInputs = [
              certifi
              cryptography
              jsons
              requests
              aiohttp
              semantic-version
              scapy
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
          below = "9";
        };
        action = [
          {
            service = "light.turn_on";
            data = {
              brightness_pct = 15;
              color_temp = 300;
            };
            target = {
              entity_id = "light.kitchen_over_cabinet_lights";
            };
          }
          {
            wait_for_trigger = {
              platform = "state";
              entity_id = "binary_sensor.lumi_lumi_motion_ac02_motion";
              from = "on";
              to = "off";
              for = {
                seconds = 90;
              };
            };
          }
          {
            service = "light.turn_off";
            target = {
              entity_id = "light.kitchen_over_cabinet_lights";
            };
          }
        ];
      }
    ];
  };
}
