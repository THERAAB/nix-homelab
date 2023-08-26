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
              hash = "";
            };

            propagatedBuildInputs = [
            ];
          }
        )
      ];
  };
}
