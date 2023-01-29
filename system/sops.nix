{ config, pkgs, ... }:
{
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;
  sops.age.sshKeyPaths = [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ];
  sops.gnupg.sshKeyPaths = [];
  sops.secrets = {
    git_config = {
      owner = "raab";
      path = "/home/raab/.config/.gitconfig";
    };
    pushbullet_api_key = {
      neededForUsers = true;
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
