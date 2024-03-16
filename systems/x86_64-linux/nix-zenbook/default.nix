{self, ...}: {
  imports = [
    (self + /share/nixos/workstation)
    ./hardware.nix
    ./hardware-configuration.nix
  ];
  nix-homelab.workstation.enable = true;
}
