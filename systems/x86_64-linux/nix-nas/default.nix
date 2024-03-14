{...}: {
  imports = [
    ./hardware.nix
    ./netdata.nix
    ./media.nix
  ];
  nix-homelab = {
    core.enable = true;
    networking.nfs.enable = true;
  };
}
