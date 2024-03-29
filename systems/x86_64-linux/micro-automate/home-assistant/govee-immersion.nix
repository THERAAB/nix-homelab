{pkgs, ...}: let
  devices = import ./devices.properties.nix;
in {
  services.home-assistant = {
    customComponents = [
      pkgs.nix-homelab.hacs-govee
    ];
    extraPackages = pythonPackages:
      with pythonPackages; [
        (
          buildPythonPackage rec {
            pname = "govee_api_laggat";
            version = "0.2.2";
            src = fetchPypi {
              inherit version pname;
              hash = "sha256-6nZzc3zY9UXGFK7r1SeOMzEzIwakW5anbu7lJwWqwI4=";
            };
            propagatedBuildInputs = [
              pkgs.nix-homelab.bios
              pexpect
              events
              pygatt
              aiohttp
              certifi
              dacite
              pytest
            ];
          }
        )
      ];
    config.automation = [
      {
        alias = "Turn on Govee with TV after sunset ${devices.living-room.lamp-sunset-offset}";
        trigger = {
          platform = "state";
          entity_id = devices.entity-id.living-room.android-tv;
          from = "off";
          to = "idle";
        };
        condition = {
          condition = "sun";
          after = "sunset";
          after_offset = devices.living-room.lamp-sunset-offset;
        };
        action = {
          service = "light.turn_on";
          target = {
            entity_id = devices.entity-id.living-room.govee-immersion;
          };
        };
      }
      {
        alias = "Turn off Govee with TV";
        trigger = {
          platform = "state";
          entity_id = devices.entity-id.living-room.android-tv;
          from = "idle";
          to = "off";
        };
        action = {
          service = "light.turn_off";
          target = {
            entity_id = devices.entity-id.living-room.govee-immersion;
          };
        };
      }
    ];
  };
}
