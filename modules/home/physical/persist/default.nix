{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab;
let
  cfg = config.nix-homelab.physical.persist;
in
{
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
        ".local/share/kpeoplevcard"
        ".local/share/kpeople"
      ];
      files = [
        ".ssh/known_hosts"
        ".config/mimeapps.list"
        ".local/state/kdeconnect.smsstaterc"
      ];
    };
  };
}
