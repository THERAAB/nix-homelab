{...}: {
  imports = [
    ./users.nix
    ./hardware.nix
    ./sops.nix
    ./syncthing.nix
    ./restic.nix
    ./microvm.nix
    ./olivetin
  ];
  nix-homelab = {
    physical.enable = true;
    networking.harmonia.enable = true;
  };
  services.netdata.config.registry.enabled = "yes";
}
