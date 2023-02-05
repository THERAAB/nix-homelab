# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  # example = pkgs.callPackage ./example { };
  olivetin = pkgs.callPackage ./olivetin { };
  hacs-govee = pkgs.callPackage ./hacs-govee { };
}