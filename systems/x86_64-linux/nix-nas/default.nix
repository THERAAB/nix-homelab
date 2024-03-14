{...}: {
  imports = [
    ./hardware.nix
    ./netdata.nix
    ./media.nix
  ];
  nix-homelab = {
    physical.enable = true;
    networking.nfs.enable = true;
  };
}
