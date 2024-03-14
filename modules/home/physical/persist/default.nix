{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical.persist;
in {
  options.nix-homelab.physical.persist = with types; {
    enable = mkEnableOption (lib.mdDoc "System");
  };
  config = mkIf cfg.enable {
    home.persistence."/nix/persist/home/raab" = {
      allowOther = true;
      directories = [
        ".config/sops/age"
        ".config/fish"
        ".cache.tealdeer"
        ".cache/nvim"
        ".local/share/fish"
        ".local/share/zoxide"
        ".local/share/atuin"
      ];
      files = [
        ".ssh/known_hosts"
        ".ssh/id_rsa"
      ];
    };
  };
}
