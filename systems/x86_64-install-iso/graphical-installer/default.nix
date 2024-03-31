{
  pkgs,
  lib,
  ...
}: {
  # `install-iso` adds wireless support that
  # is incompatible with networkmanager.
  networking.wireless.enable = lib.mkForce false;
  environment.systemPackages = with pkgs; [
    gnome-text-editor
    gnome.nautilus
    alejandra
    gparted
    acpi
    vim
    hw-probe
    nvme-cli
    sysfsutils
    git
    vscode
    kitty
  ];
  nix-homelab = {
    workstation = {
      gnome.enable = true;
    };
    core.enable = true;
    physical = {
      fish.enable = true;
      starship.enable = true;
    };
  };
}
