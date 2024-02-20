{...}: {
  imports = [
    ./adguard
    ./home-assistant
    ./hardware-configuration.nix
    ./netdata.nix
    ./users.nix
    ./hardware.nix
    ./sops.nix
    ./harmonia.nix
    ./syncthing.nix
    ./nfs.nix
    ./auto-upgrade.nix
    ./restic.nix
    ./microvm
    ./caddy.nix
  ];
}
