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
            pname = "plugp100";
            version = "3.12.0";
            src = fetchPypi {
              inherit version pname;
              hash = "sha256-jfitt8qCq8nRbCgv81qz3Wtwp0R9fXQ7TjP88Sh2oIY=";
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
    ];
  };
}
