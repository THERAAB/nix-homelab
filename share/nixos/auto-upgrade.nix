{ config, pkgs, ... }:
{
  systemd.services = {
    nixos-upgrade.onFailure = [ "nixos-upgrade-on-failure.service" ];
    nixos-upgrade-on-failure = {
      script = ''
        TOKEN=`cat ${config.sops.secrets.pushbullet_api_key.path}`
        HOSTNAME=`${pkgs.nettools}/bin/hostname`

        echo '{"type":"note","title":"'$HOSTNAME' Upgrade Failed","body":"Upgrade failed on '$HOSTNAME', run journalctl -u nixos-upgrade for details"}' > body.json

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