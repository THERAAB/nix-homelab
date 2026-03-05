{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.persist;
in {
  options.nix-homelab.workstation.persist = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup impermanence home manager module");
  };
  config = mkIf cfg.enable {
    home.persistence."/nix/persist" = {
      directories = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        ".mozilla"
        ".config/VSCodium"
        ".config/Code"
        ".config/openrazer"
        ".config/polychromatic"
        ".config/dconf"
        ".config/maestral"
        ".config/discord"
        ".config/libreoffice"
        ".config/cef_user_data" # Steam
        ".config/JetBrains"
        ".config/forge"
        ".config/gsconnect"
        ".config/Bitwarden"
        ".cache/mozilla"
        ".cache/matplotlib" # Fonts
        ".cache/fontconfig"
        ".cache/libreoffice"
        ".cache/gsconnect"
        ".cache/libgweather"
        ".dropbox-dist"
        ".dropbox-hm"
        ".pki" # Discord
        ".vmware"
        ".omnissa"
        ".local/share/org.gnome.TextEditor"
        ".local/share/maestral"
        ".local/share/python_keyring" # Maestral
        ".local/state/wireplumber"
        ".local/share/Steam"
        ".local/share/JetBrains"
        ".local/share/vulkan"
        ".local/share/icons"
        ".local/share/applications"
        ".local/share/Jellyfin Media Player"
        ".local/share/jellyfinmediaplayer"
        ".local/share/keyrings"
        ".local/share/vicinae"
        ".java" # IntelliJ
        ".compose-cache" # Steam
      ];
      files = [
        ".config/monitors.xml" # Gnome
      ];
    };
  };
}
