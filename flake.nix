{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixinate.url = "github:matthewcroughan/nixinate";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: let
    self = inputs.self;
    properties = import (self + /assets/properties);
  in
    inputs.snowfall-lib.mkFlake {
      inherit inputs self;
      src = ./.;
      snowfall.namespace = "nix-homelab";
      channels-config.allowUnfree = true;
      apps = inputs.nixinate.nixinate.x86_64-linux self;

      systems = {
        modules.nixos = with inputs; [
          home-manager.nixosModules.home-manager
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
        ];
        hosts = {
          nix-hypervisor = {
            specialArgs = {
              inherit self properties;
            };
          };
          nix-nas.specialArgs = {
            inherit self properties;
          };
          nix-zenbook.specialArgs = {
            inherit self properties;
          };
          nix-desktop.specialArgs = {
            inherit self properties;
          };
          graphical-installer.specialArgs = {
            inherit self properties;
          };
        };
      };
    };
}
