{...}: {
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
    ./system.nix
    ./netdata.nix
    ./nfs.nix
    ./media.nix
    ./pkgs.nix
    ./snapper.nix
  ];
}
