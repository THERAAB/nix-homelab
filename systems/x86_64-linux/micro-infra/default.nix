{self, ...}: {
  imports = [
    (self + /share/nixos/microvm)
    ./adguard.nix
    ./hardware.nix
  ];
  nix-homelab = {
    microvm.enable = true;
    wrappers = {
      gatus = {
        enable = true;
        conf = import ./gatus.nix;
      };
      homer = {
        enable = true;
        conf = import ./homer.nix;
      };
      gotify.enable = true;
      unifi.enable = true;
    };
  };
}
