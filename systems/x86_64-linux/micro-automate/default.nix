{self, ...}: {
  imports = [
    (self + /share/nixos/microvm)
    ./hardware.nix
    ./home-assistant
  ];
  nix-homelab = {
    microvm.enable = true;
    # wrappers.home-assistant.enable = true;
  };
}
