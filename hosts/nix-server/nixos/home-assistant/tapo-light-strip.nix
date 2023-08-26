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
  };
}
