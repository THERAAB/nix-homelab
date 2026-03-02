{self, ...}: {
  imports = [
    ./hardware.nix
    ./adguard-tailscale.nix
  ];
  nix-homelab = {
    microvm.enable = true;
  };
}
