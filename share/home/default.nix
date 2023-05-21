{...}: {
  imports = [
    ./persist.nix
    ./git.nix
    ./pkgs.nix
    ./home.nix
    ./nixvim.nix
    ./fish.nix
    ./helix.nix
  ];
}
