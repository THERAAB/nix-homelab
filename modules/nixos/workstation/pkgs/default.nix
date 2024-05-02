{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.pkgs;
in {
  options.nix-homelab.workstation.pkgs = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup configuration.nix");
  };
  config = mkIf cfg.enable {
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
      chromium
      nvme-cli
      stress
      sysfsutils
    ];
  };
}
