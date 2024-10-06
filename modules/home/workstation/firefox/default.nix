{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.firefox;
in {
  options.nix-homelab.workstation.firefox = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup firefox");
  };
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
          CaptivePortal = true;
          DisableFirefoxStudies = true;
          DisableTelemetry = true;
          DisablePocket = true;
          DisableFirefoxAccounts = false;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          OfferToSaveLoginsDefault = false;
          PasswordManagerEnabled = false;
          UserMessaging = {
            ExtensionRecommendations = false;
            SkipOnboarding = true;
          };
        };
      };
      profiles.default = {
        id = 0;
        isDefault = true;
        name = "Default";
        search = {
          default = "DuckDuckGo";
          force = true;
        };
        settings = {
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.aboutConfig.showWarning" = "false";
          "browser.urlbar.maxRichResults" = 20;
          "layout.spellcheckDefault" = 2;
          "media.ffmpeg.vaapi.enabled" = true;
          "full-screen-api.warning.timeout" = 0;
          "browser.tabs.tabmanager.enabled" = false;
          "apz.overscroll.enabled" = true;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "geo.enabled" = false;
          "browser.search.suggest.enabled" = false;
          "signon.rememberSignons" = false;
        };
      };
    };
  };
}
