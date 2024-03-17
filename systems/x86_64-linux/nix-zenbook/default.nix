{self, ...}: {
  imports = [
    (self + /share/nixos/workstation)
    ./hardware.nix
  ];
  nix-homelab.workstation.enable = true;
}
