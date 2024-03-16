{self, ...}: {
  imports = [
    (self + /share/nixos/server)
    ./users.nix
    ./hardware.nix
    ./sops.nix
    ./syncthing.nix
    ./restic.nix
    ./microvm.nix
    ./olivetin
    ./update-flake.nix
  ];
  nix-homelab = {
    server.enable = true;
    networking.harmonia.enable = true;
  };
  services.netdata.config.registry.enabled = "yes";
}
