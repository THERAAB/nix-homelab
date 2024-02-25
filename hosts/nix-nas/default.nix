{...}: {
  imports = [
    ./hardware.nix
    ./system.nix
    ./netdata.nix
    ./nfs.nix
    ./media.nix
  ];
}
