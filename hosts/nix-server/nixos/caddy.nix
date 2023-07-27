{...}: let
  network = import ../../../share/network.properties.nix;
in {
  services.caddy = {
    enable = true;
  };
}
