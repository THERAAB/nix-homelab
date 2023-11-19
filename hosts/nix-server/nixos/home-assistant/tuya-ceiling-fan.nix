{pkgs, ...}: {
  systemd.tmpfiles.rules = [
    "R  /var/lib/hass/custom_components/smartlife   -       -       -       -   -                                                        "
    "L  /var/lib/hass/custom_components/smartlife   770     hass    hass    -   ${pkgs.tuya-smart-life}/custom_components/smartlife      "
  ];
  services.home-assistant = {
    extraPackages = pythonPackages:
      with pythonPackages; [
        (
          buildPythonPackage rec {
            pname = "tuya-device-sharing-sdk";
            version = "0.1.8";
            src = fetchPypi {
              inherit version pname;
              hash = "sha256-GR6iraccib0vlKaTugzpkSBiVQXLrXwmkIX7wsfuuyQ=";
            };
            propagatedBuildInputs = [
              paho-mqtt
              requests
              cryptography
              tuyaha
            ];
          }
        )
      ];
    config.automation = [
    ];
  };
}
