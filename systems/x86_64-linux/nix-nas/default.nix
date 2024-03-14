{...}: {
  imports = [
    ./hardware.nix
    ./netdata.nix
    ./media.nix
  ];
  nix-homelab.networking.nfs.enable = true;
}
