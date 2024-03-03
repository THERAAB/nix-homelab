{config, ...}: {
  services.harmonia = {
    enable = true;
    signKeyPath = config.sops.secrets.harmonia_secret.path;
  };
  nix.settings.allowed-users = ["harmonia"];
}
