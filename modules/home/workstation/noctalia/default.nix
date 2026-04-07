{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab;
let
  cfg = config.nix-homelab.workstation.noctalia;
in
{
  options.nix-homelab.workstation.noctalia = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup noctalia");
  };
  config = mkIf cfg.enable {
    services.kdeconnect.enable = true;
    # Fix for KDE Connect styling, see https://github.com/nix-community/stylix/issues/1958
    xdg.configFile.kdeglobals.source =
      let
        themePackage = builtins.head (
          builtins.filter (
            p: builtins.match ".*stylix-kde-theme.*" (baseNameOf p) != null
          ) config.home.packages
        );
        colorSchemeSlug = lib.concatStrings (
          lib.filter lib.isString (builtins.split "[^a-zA-Z]" config.lib.stylix.colors.scheme)
        );
      in
      "${themePackage}/share/color-schemes/${colorSchemeSlug}.colors";
    programs.noctalia-shell = {
      enable = true;
      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          tailscale = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };
        version = 1;
      };
      settings = {
        wallpaper.enabled = true;
        notifications = {
          enabled = true;
          saveToHistory = {
            low = true;
            normal = true;
            critical = true;
          };
        };
        bar = {
          outerCorners = false;
          widgets = {
            left = [
              {
                id = "Clock";
                formatHorizontal = "hh:mm AP dddd, MMMM dd";
                formatVertical = "hh:mm AP dddd, MMMM dd";
                tooltipFormat = "hh:mm AP dddd, MMMM dd";
                clockColor = "secondary";
              }
              {
                id = "SystemMonitor";
              }
              {
                id = "ActiveWindow";
                textColor = "tertiary";
              }
              {
                id = "MediaMini";
                hideWhenIdle = true;
              }
            ];
            center = [
              {
                id = "Workspace";
                labelMode = "none";
              }
            ];
            right = [
              {
                id = "Tray";
              }
              {
                id = "NotificationHistory";
                hideWhenZero = true;
                iconColor = "primary";
              }
              {
                id = "Battery";
                hideIfIdle = true;
                displayMode = "graphic";
                showPowerProfiles = true;
              }
              {
                id = "Volume";
                iconColor = "tertiary";
              }
              {
                id = "Brightness";
                iconColor = "error";
              }
              {
                id = "plugin:tailscale";
                defaultSettings = {
                  terminalCommand = "kitty";
                  compactMode = true;
                  taildropReceiveMode = "operator";
                };
              }
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
            ];
          };
        };
        general = {
          showChangelogOnStartup = false;
          telemetryEnabled = false;
          dimmerOpacity = 0.35;
        };
        dock = {
          enabled = true;
          size = 1.75;
          deadOpacity = 1.0;
          pinnedApps = [
            "firefox"
            "org.gnome.Nautilus"
            "horizon-client"
            "kitty"
            "steam"
            "dev.zed.Zed"
            "org.gnome.TextEditor"
          ];
          pinnedStatic = true;
        };
        location = {
          autoLocate = true;
          weatherShowEffects = true;
          useFahrenheit = true;
          use12hourFormat = true;
        };
        nightLight = {
          enabled = true;
          autoSchedule = true;
          nightTemp = "4000";
          dayTemp = "6500";
        };
      };
    };
  };
}
