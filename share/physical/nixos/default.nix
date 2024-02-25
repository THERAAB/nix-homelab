{...}: {
  imports = [
    ./persist.nix
    ./system.nix
    ./pkgs.nix
    ./sops.nix
    ./auto-upgrade.nix
    ./configuration.nix
    ./hardware.nix
    ./boot.nix
    ./fish.nix
    ./starship.nix
    ./netdata.nix
    ./smartd.nix
    ./users.nix
  ];
}
