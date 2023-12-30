{pkgs, ...}: {
  networking.hostName = "nix-nas"; # Define your hostname.
  powerManagement.powerUpCommands = ''
    ${pkgs.hdparm}/sbin/hdparm -S 242 /dev/sda
  '';
  systemd.services = {
    disable-interrupt-gpe6F = {
      wantedBy = ["local-fs.target"];
      after = ["local-fs.target"];
      description = "Disable CPU consuming interrupt";
      startLimitBurst = 5;
      startLimitIntervalSec = 1;
      serviceConfig = {
        Type = "oneshot";
        Restart = "on-failure";
        ExecStart = ''${pkgs.coreutils-full}/bin/echo "disable" >/sys/firmware/acpi/interrupts/gpe6F'';
      };
    };
  };
}
