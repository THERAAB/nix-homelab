{...}: {
  imports = [
    ./hardware.nix
    ./media.nix
  ];
  nix-homelab = {
    physical.enable = true;
    networking.nfs.enable = true;
  };
  services.netdata.config.registry.enabled = "no";
}
