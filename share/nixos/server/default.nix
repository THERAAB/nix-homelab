{...}: {
  imports = [
    ../physical
  ];
  environment.persistence."/nix/persist/system" = {
    directories = [
      "/var/cache/netdata"
      "/var/www/"
    ];
  };
  sops = {
    keepGenerations = 0;
    secrets = {
      gatus_env = {};
      restic_password = {};
      netdata_alarm = {};
      beszel_agent_env = {
        owner = "beszel-agent";
      };
    };
  };
}
