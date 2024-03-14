{...}: {
  imports = [
    ./hardware.nix
    ./netdata.nix
    ./media.nix
  ];
  nix-homelab = {
    core = {
      flakes.enable = true;
      system.enable = true;
    };
    networking.nfs.enable = true;
  };
}
