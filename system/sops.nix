{ config, pkgs, ... }:
{
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;
  sops.secrets = {
    git_config = {
      owner = "raab";
      path = "/home/raab/.config/.gitconfig";
    };
    pushbullet_api_key = {
      owner = "gatus";
      restartUnits = [ "podman-gatus.service" ];
    };
    home_assistant = {
      owner = "hass";
      path = "/var/lib/hass/secrets.yaml";
    };
    wireguard_mullvad = {
       owner = "vuetorrent";
    };
    git_ssh_key = {
      owner = "raab";
      path = "/home/raab/.ssh/id_rsa";
    };
  };
}
