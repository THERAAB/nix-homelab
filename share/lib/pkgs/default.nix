# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{pkgs ? (import ../../nixpkgs.nix) {}}: {
  olivetin = pkgs.callPackage ./olivetin {};
  hacs-govee = pkgs.callPackage ./hacs-govee {};
  home-assistant-tapo-p100 = pkgs.callPackage ./home-assistant-tapo-p100 {};
  localtuya = pkgs.callPackage ./localtuya {};
  bios = pkgs.python3Packages.callPackage ./bios {};
}
