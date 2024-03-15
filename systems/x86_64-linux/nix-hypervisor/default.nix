{...}: {
  imports = [
    ./users.nix
    ./hardware.nix
    ./sops.nix
    ./syncthing.nix
    ./restic.nix
    ./microvm.nix
  ];
  nix-homelab = {
    physical.enable = true;
    wrappers.olivetin.enable = true;
    networking.harmonia.enable = true;
  };
  services.netdata.config.registry.enabled = "yes";
}
