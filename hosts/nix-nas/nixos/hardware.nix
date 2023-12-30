{pkgs, ...}: {
  networking.hostName = "nix-nas"; # Define your hostname.
  powerManagement.powerUpCommands = ''
    ${pkgs.hdparm}/sbin/hdparm -S 242 /dev/sda
  '';
  systemd.services = {
    disable-interrupt-gpe6F = {
      wantedBy = ["network-online.target"];
      after = ["network-online.target"];
      description = "Disable CPU consuming interrupt";
      startLimitBurst = 5;
      startLimitIntervalSec = 120;
      serviceConfig = {
        Type = "oneshot";
        Restart = "on-failure";
        ExecStart = ''
        ${pkgs.coreutils-full}/bin/sleep 10 && ${pkgs.runtimeShell} -c 'echo disable >/sys/firmware/acpi/interrupts/gpe6F'
        '';
      };
    };
  };
}
