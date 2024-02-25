{pkgs, ...}: let
  network = import ../../share/network.properties.nix;
in {
  nix.settings = {
    substituters = ["https://cache.${network.domain}"];
    trusted-public-keys = ["cache.${network.domain}:IqbrtbXMzwCjSVZ/sWowaPXtjS+CtpCpStmabZI2TSo="];
  };
  boot.initrd.availableKernelModules = ["sdhci_pci"];
  powerManagement.powerUpCommands = ''
    ${pkgs.hdparm}/sbin/hdparm -S 242 /dev/sda
    ${pkgs.hdparm}/sbin/hdparm -S 242 /dev/sdb
  '';
  networking = {
    hostName = "nix-nas";
    enableIPv6 = false;
  };
  # disable interrupt which uses high CPU for ACPI (IRQ 9)
  # Found it from highest number in below command:
  # sudo grep . -r /sys/firmware/acpi/interrupts | grep -v "  0"
  systemd.services.disable-interrupt-gpe6F = {
    wantedBy = ["network-online.target"];
    after = ["network-online.target"];
    description = "Disable CPU consuming interrupt";
    startLimitBurst = 5;
    startLimitIntervalSec = 60;
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
      ExecStart = toString (pkgs.writeShellScript "disable-interrupt-gpe6F" ''
        ${pkgs.coreutils-full}/bin/sleep 10
        echo disable >/sys/firmware/acpi/interrupts/gpe6F
      '');
    };
  };
}
