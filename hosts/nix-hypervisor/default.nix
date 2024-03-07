{...}: {
  imports = [
    ./olivetin
    ./netdata.nix
    ./users.nix
    ./hardware.nix
    ./sops.nix
    ./harmonia.nix
    ./syncthing.nix
    ./nfs.nix
    ./auto-upgrade.nix
    ./restic.nix
    ./microvm.nix
    #../../share/optional/acme.nix
  ];
}
