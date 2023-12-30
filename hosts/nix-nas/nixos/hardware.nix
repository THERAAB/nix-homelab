{pkgs, ...}: {
  networking.hostName = "nix-nas"; # Define your hostname.
  powerManagement.powerUpCommands = ''
    echo disable > /sys/firmware/acpi/interrupts/gpe6F
    ${pkgs.hdparm}/sbin/hdparm -S 242 /dev/sda
  '';
}
