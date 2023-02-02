{ config, pkgs, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    ./system
  ];
  
  nix = {
    # Flake setup
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
    
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  systemd.services = {
    nixos-upgrade.onFailure = [ "nixos-upgrade-on-failure.service" ];
    nixos-upgrade-on-failure = {
      script = ''
        TOKEN=`cat ${config.sops.secrets.pushbullet_api_key.path}`
        echo '{"type":"note","title":"Nixos Upgrade Failed","body":"' > body.json
        journalctl -n 15 -o verbose -u nixos-upgrade.service  >> body.json
        echo '"}' >> body.json

        ${pkgs.dos2unix}/bin/unix2dos body.json
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
