{self, ...}: {
  imports = [
    (self + /share/nixos/microvm)
    ./hardware.nix
    ./adguard-tailscale.nix
  ];
  nix-homelab = {
    microvm.enable = true;
  };
}
