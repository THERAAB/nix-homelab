{self, ...}: {
  sops = {
    defaultSopsFile = self + /secrets/secrets.yaml;
    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
      sshKeyPaths = ["/nix/persist/system/etc/ssh/ssh_host_ed25519_sops"];
    };
    gnupg.sshKeyPaths = [];
    secrets = {
      git_config = {
        owner = "raab";
        path = "/nix/persist/home/raab/.config/.gitconfig";
      };
      gotify_homelab_token = {};
      git_ssh_key = {
        owner = "raab";
        path = "/nix/persist/home/raab/.ssh/id_rsa";
      };
    };
  };
}
