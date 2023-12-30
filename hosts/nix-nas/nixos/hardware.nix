{...}: {
  networking.hostName = "nix-nas"; # Define your hostname.
  powerManagement.powerUpCommands = ''
    echo disable > /sys/firmware/acpi/interrupts/gpe6F
  ''; # Disable otherwise ACPI IRQ Routing for interrupt 9 consumes 20% CPU 
}
