{...}: {
  imports = [
    ../physical
  ];
  environment.persistence."/nix/persist/system" = {
    directories = [
      "/var/www/"
    ];
  };
  sops = {
    keepGenerations = 0;
    secrets = {
      gatus_env = {};
      restic_password = {};
      beszel_agent_env = {
        owner = "beszel-agent";
      };
    };
  };
}
