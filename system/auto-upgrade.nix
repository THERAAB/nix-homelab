{ config, pkgs, ... }:
{
  systemd.services = {
    nixos-upgrade.onFailure = [ "nixos-upgrade-on-failure.service" ];
    nixos-upgrade-on-failure = {
      script = ''
        TOKEN=`cat ${config.sops.secrets.pushbullet_api_key.path}`

        echo '{"type":"note","title":"Nixos Upgrade Failed","body":"' > body.json
        journalctl -o json-seq -n 15 -u nixos-upgrade.service  >> body.json
        echo '"}' >> body.json

        ${pkgs.curl}/bin/curl   -H "Access-Token: $TOKEN"               \
                                -H "Content-Type: application/json"     \
                                -X POST                                 \
                                -d @body.json                           \
                                https://api.pushbullet.com/v2/pushes
      '';
    };
  };

  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
    flake = "/nix/persist/nix-homelab";
    flags = [
      "--update-input" "nixpkgs"
    ];
    allowReboot = true;
  };
}