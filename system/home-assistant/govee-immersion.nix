{ config, pkgs, ... }:
let
  hacs-govee = pkgs.fetchFromGitHub rec {
    owner  = "LaggAt";
    repo   = "hacs-govee";
    rev    = "0.2.2";
    sha256 = "sha256-vIBx+t+AcWG9z7O5bv4yMMCplpc54N29/QxMUwHjeSU=";
  };
  devices = (import ./properties.nix).devices;
in
{
  systemd.tmpfiles.rules = [
    "C  /var/lib/hass/custom_components/govee 770    hass hass    -   ${hacs-govee}/custom_components/govee "
  ];
  services.home-assistant = {
    extraPackages = python3Packages: with python3Packages; [
      (
        buildPythonPackage rec {
          pname = "govee_api_laggat";
          version = "0.2.2";
          src = fetchPypi {
            inherit version pname;
            hash = "sha256-6nZzc3zY9UXGFK7r1SeOMzEzIwakW5anbu7lJwWqwI4=";
          };

          propagatedBuildInputs = [
            (
              buildPythonPackage rec {
                pname = "bios";
                version = "0.1.2";
                src = fetchPypi {
                  inherit pname version;
                  hash = "sha256-vM/CQBG2pjGm7e7xBpVRpOyq/3s+1QpiIaaAdYUFAOk=";
                };

                propagatedBuildInputs = [
                  oyaml pyyaml
                ];
              }
            )
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