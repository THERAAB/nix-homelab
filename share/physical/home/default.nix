{...}: {
  imports = [
    ./persist.nix
    ./git.nix
    ./pkgs.nix
    ./home.nix
    ./neovim.nix
  ];
  nix-homelab.physical.fish.enable = true;
}
