{
  properties,
  pkgs,
  ...
}: let
  nfs-dir = "/nfs";
  media-dir = "${nfs-dir}/media";
  backups-dir = "${nfs-dir}/backups";
in {
  nix.settings = {
    substituters = ["https://cache.${properties.network.domain}"];
    trusted-public-keys = ["cache.${properties.network.domain}:IqbrtbXMzwCjSVZ/sWowaPXtjS+CtpCpStmabZI2TSo="];
  };
  boot.initrd.availableKernelModules = ["sdhci_pci"];
  powerManagement.powerUpCommands = ''
    ${pkgs.hdparm}/sbin/hdparm -S 242 /dev/sda
    ${pkgs.hdparm}/sbin/hdparm -S 242 /dev/sdb
  '';
  networking = {
    hostName = "nix-nas";
    networkmanager.enable = false; # networkmanager hangs on poweroff due to some ipv6 issues
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
  fileSystems = {
    "${media-dir}" = {
      device = "/dev/disk/by-label/media";
      fsType = "btrfs";
      options = ["subvol=media" "compress=zstd" "noatime"];
    };
    "${backups-dir}" = {
      device = "/dev/disk/by-label/media";
      fsType = "btrfs";
      options = ["subvol=backups" "compress=zstd" "noatime"];
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${media-dir}/downloads    -       -       -       -   - "
    "d    ${media-dir}/movies       -       -       -       -   - "
    "d    ${media-dir}/tv           -       -       -       -   - "
    "d    ${media-dir}/audiobooks   -       -       -       -   - "
    "d    ${media-dir}/podcasts     -       -       -       -   - "
  ];
  users.groups.media.gid = properties.users.media.gid;
}
