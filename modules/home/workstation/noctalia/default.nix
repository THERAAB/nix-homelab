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
          kde-connect = {
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
        ui.panelBackgroundOpacity = lib.mkForce 0.75;
        bar = {
          outerCorners = false;
          widgets = {
            left = [
              {
                id = "Clock";
                formatHorizontal = "hh:mm AP ddd, MMM dd";
                formatVertical = "hh:mm AP ddd, MMM dd";
                tooltipFormat = "hh:mm AP ddd, MMM dd";
              }
              {
                id = "SystemMonitor";
              }
              {
                id = "ActiveWindow";
              }
              {
                id = "MediaMini";
                hideWhenIdle = true;
              }
            ];
            center = [
              {
                id = "Workspace";
              }
            ];
            right = [
              {
                id = "Tray";
              }
              {
                id = "NotificationHistory";
                hideWhenZero = true;
              }
              {
                id = "Battery";
                hideIfIdle = true;
                displayMode = "graphic";
                showPowerProfiles = true;
              }
              {
                id = "Volume";
              }
              {
                id = "Brightness";
              }
              {
                id = "plugin:kde-connect";
              }
              {
                id = "ControlCenter";
              }
            ];
          };
        };
        general = {
          showChangelogOnStartup = false;
          telemetryEnabled = false;
        };
        dock = {
          enabled = true;
          size = 1.75;
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
          name = "New York, New York";
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
