{ pkgs ? (import ../nixpkgs.nix) { } }: {
  olivetin = pkgs.callPackage ./olivetin { };
  hacs-govee = pkgs.callPackage ./hacs-govee { };
  bios = python3Packages.callPackage ./bios { };
}