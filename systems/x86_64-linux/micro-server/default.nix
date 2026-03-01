{self, ...}: {
  imports = [
    (self + /share/nixos/microvm)
    ./hardware.nix
  ];
  nix-homelab = {
    microvm.enable = true;
    wrappers = {
      photoprism.enable = true;
    };
  };
}
