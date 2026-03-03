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
    enable = mkEnableOption (lib.mdDoc "Persist files");
  };
  config = mkIf cfg.enable {
    home.persistence."/nix/persist" = {
      directories = [
        ".config/sops/age"
        ".config/nix"
        ".config/fish"
        ".cache.tealdeer"
        ".cache/nvim"
        ".local/share/fish"
        ".local/share/zoxide"
        ".local/share/atuin"
      ];
      files = [
        ".ssh/known_hosts"
        # ".ssh/id_rsa"
      ];
    };
  };
}
