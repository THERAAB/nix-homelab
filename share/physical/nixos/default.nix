{...}: {
  imports = [
    ./persist.nix
    ./system.nix
    ./pkgs.nix
    ./sops.nix
    ./auto-upgrade.nix
    ./hardware.nix
    ./fish.nix
    ./starship.nix
    ./netdata.nix
    ./smartd.nix
    ./users.nix
    ./hardware-configuration.nix
  ];
}
