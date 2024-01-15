<<<<<<< Updated upstream
{...}: 
let
  network = import ../../../share/network.properties.nix;
in
{
=======
{...}: {
>>>>>>> Stashed changes
  nix.settings = {
    substituters = ["https://cache.${network.domain}"];
    trusted-public-keys = ["cache.${network.domain}:IqbrtbXMzwCjSVZ/sWowaPXtjS+CtpCpStmabZI2TSo="];
  };
}
