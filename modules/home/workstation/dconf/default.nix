{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.dconf;
in {
  options.nix-homelab.workstation.dconf = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup dconf for gnome/gtk apps");
  };
  config = mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/TextEditor" = {
        highlight-current-line = true;
        show-line-numbers = true;
        style-scheme = "peninsula-dark";
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        monospace-font-name = lib.mkDefault "JetBrainsMono Nerd Font 10";
        gtk-theme = "catppuccin-frappe-blue-standard";
        cursor-theme = "phinger-cursors-light";
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ""; # Hide close button on titlebar for apps like firefox
      };
    };

    # Extra dconf settings which can't be covered by dconf module due to timing or syntax issues
    systemd.user.services.extra-dconf = {
      Install.WantedBy = ["graphical-session.target"];
      Unit.After = ["graphical-session.target"];
      Service.ExecStart = toString (pkgs.writeShellScript "extra-dconf" ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/weather/locations "[<(uint32 2, <('New York City, Central Park', 'KNYC', false, [(0.71180344078725644, -1.2909618758762367)], @a(dd) [])>)>]"
        ${pkgs.dconf}/bin/dconf write /org/gnome/mutter/experimental-features "['scale-monitor-framebuffer']"
      '');
    };
  };
}
