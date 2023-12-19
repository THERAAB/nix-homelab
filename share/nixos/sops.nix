{...}: {
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = true;
    age.sshKeyPaths = ["/nix/persist/system/etc/ssh/ssh_host_ed25519_sops"];
    gnupg.sshKeyPaths = [];
    secrets = {
      git_config = {
        owner = "raab";
        path = "/nix/persist/home/raab/.config/.gitconfig";
      };
      pushbullet_api_key = {
        neededForUsers = true;
      };
      gotify_token = {
        neededForUsers = true;
      };
      git_ssh_key = {
        owner = "raab";
        path = "/nix/persist/home/raab/.ssh/id_rsa";
      };
    };
  };
}
