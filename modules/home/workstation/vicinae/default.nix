{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab;
let
  cfg = config.nix-homelab.workstation.vicinae;
in
{
  options.nix-homelab.workstation.vicinae = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup vicinae`");
  };
  config = mkIf cfg.enable {
    programs.vicinae = {
      enable = true;
      systemd = {
        enable = true;
      };
      extensions = [
        (config.lib.vicinae.mkExtension {
          name = "nix";
          src =
            pkgs.fetchFromGitHub {
              owner = "vicinaehq";
              repo = "extensions";
              rev = "50233dff9dfc70fc6b39c2387687e5661b09f005";
              sha256 = "sha256-GVIbXYiA506LV0cEsG1AA4vTwDJq9R6v6lFFs8z7knY=";
            }
            + "/extensions/nix";
        })
        (config.lib.vicinae.mkExtension {
          name = "firefox";
          src =
            pkgs.fetchFromGitHub {
              owner = "vicinaehq";
              repo = "extensions";
              rev = "50233dff9dfc70fc6b39c2387687e5661b09f005";
              sha256 = "sha256-GVIbXYiA506LV0cEsG1AA4vTwDJq9R6v6lFFs8z7knY=";
            }
            + "/extensions/firefox";
        })
      ];
      settings = {
        font.family = "system";
        launcher_window.opacity = lib.mkForce 0.95;
        pop_to_root_on_close = true;
        theme.dark.icon_theme = "Papirus-Dark";
        favorites = [ ];
        activate_on_single_click = true;
      };
    };
  };
}
