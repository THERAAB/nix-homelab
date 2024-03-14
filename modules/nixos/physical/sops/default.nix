{
  lib,
  config,
  self,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical.sops;
in {
  options.nix-homelab.physical.sops = with types; {
    enable = mkEnableOption (lib.mdDoc "System");
  };
  config = mkIf cfg.enable {
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
        gotify_gatus_token = {};
        gotify_homelab_token = {};
        restic_password = {};
        netdata_alarm = {};
        git_ssh_key = {
          owner = "raab";
          path = "/nix/persist/home/raab/.ssh/id_rsa";
        };
      };
    };
  };
}
