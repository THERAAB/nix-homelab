{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.configuration;
in {
  options.nix-homelab.workstation.configuration = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup configuration.nix");
  };
  config = mkIf cfg.enable {
    boot = {
      initrd.verbose = false;
      consoleLogLevel = 0;
      kernelParams = ["quiet" "splash" "rd.systemd.show_status=false" "udev.log_priority=3" "boot.shell_on_fail"];
      loader.grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        configurationLimit = 10;
        gfxmodeEfi = "text";
        splashImage = null;
      };
    };
    environment.systemPackages = with pkgs; [
      pulseaudio # needed to use pactl on pipewire
      dmidecode
      libnotify
      wmctrl
      gnome-text-editor
      gnome.nautilus
      helix
      gnome.ghex
      pavucontrol
      xorg.xlsclients
      nil
      alejandra
      wl-clipboard
      acpica-tools
      gparted
      acpi
      vim
      hw-probe
      google-chrome
      nvme-cli
      stress
      sysfsutils
    ];
  };
}
