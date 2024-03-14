{...}: {
  imports = [
    ./persist.nix
    ./sops.nix
  ];
  nix-homelab.physical = {
    autoUpgrade.enable = true;
    configuration.enable = true;
    fish.enable = true;
    hardware.enable = true;
    netdata.enable = true;
    nox.enable = true;
    smartd.enable = true;
    starship.enable = true;
    system.enable = true;
    users.enable = true;
    hardware-configuration.enable = true;
  };
}
