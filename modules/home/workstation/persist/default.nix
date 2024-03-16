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
    home.persistence."/nix/persist/home/raab" = {
      allowOther = true;
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
        ".config/ulauncher"
        ".config/forge"
        ".config/gsconnect"
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
        ".local/share/org.gnome.TextEditor"
        ".local/share/maestral"
        ".local/share/python_keyring" # Maestral
        ".local/state/wireplumber"
        ".local/share/Steam"
        ".local/share/JetBrains"
        ".local/share/vulkan"
        ".local/share/icons"
        ".local/share/applications"
        ".local/share/ulauncher"
        ".local/share/Jellyfin Media Player"
        ".local/share/jellyfinmediaplayer"
        ".java" # IntelliJ
        ".compose-cache" # Steam
      ];
      files = [
        ".config/monitors.xml" # Gnome
      ];
    };
  };
}
