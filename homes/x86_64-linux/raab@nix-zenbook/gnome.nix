{pkgs, ...}: {
  dconf.settings = {
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      speed = 0.19298245614035081;
    };
    "org/gnome/shell" = {
      last-selected-power-profile = "power-saver";
      enabled-extensions = [
        "swap-finger-gestures-3-4@icedman.github.com"
      ];
    };
    "org/gnome/desktop/interface" = {
      enable-hot-corners = true;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "suspend";
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      static-blur = true;
    };
    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
    };
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };
    "org/gnome/shell/extensions/just-perfection" = {
      panel-in-overview = true;
      panel = false;
    };
  };
  home.packages = with pkgs; [
    gnomeExtensions.swap-finger-gestures-3-to-4
  ];
}
