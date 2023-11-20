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
            version = "ababca70879ac103bfe12662753e0b7a1bd4f80a";
            src = pkgs.fetchFromGitHub {
              inherit version pname;
              repo = pname;
              rev = version;
              owner = "tuya";
              sha256 = "sha256-qMogMIZyQM/Dw3audRxUA6OECrFfOo9Jcww40e0RBIw=";
            };
            propagatedBuildInputs = [
              paho-mqtt
              requests
              cryptography
            ];
          }
        )
      ];
    config.automation = [
    ];
  };
}
