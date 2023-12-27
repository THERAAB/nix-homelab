{...}: {
  nix.settings = {
    substituters = ["https://cache.pumpkin.rodeo"];
    trusted-public-keys = ["cache.pumpkin.rodeo:IqbrtbXMzwCjSVZ/sWowaPXtjS+CtpCpStmabZI2TSo="];
  };
}
