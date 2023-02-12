# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  olivetin = pkgs.callPackage ./olivetin { };
  r8168 = pkgs.callPackage ./r8168 { };
  hacs-govee = pkgs.callPackage ./hacs-govee { };
  bios = pkgs.python3Packages.callPackage ./bios { };
}