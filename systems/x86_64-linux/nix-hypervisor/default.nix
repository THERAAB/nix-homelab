{...}: {
  imports = [
    ./users.nix
    ./hardware.nix
    ./sops.nix
    ./harmonia.nix
    ./syncthing.nix
    ./restic.nix
    ./microvm.nix
  ];
  nix-homelab = {
    physical.enable = true;
    wrappers = {
      olivetin.enable = true;
    };
  };
  services.netdata.config.registry.enabled = "yes";
}
