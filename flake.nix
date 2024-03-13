{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixinate.url = "github:matthewcroughan/nixinate";
  };
  outputs = inputs: let
    self = inputs.self;
    properties = import (self + /assets/properties);
    microvms = {
      modules = with inputs; [
        microvm.nixosModules.microvm
        ./share/microvm
      ];
      specialArgs = {
        inherit self properties;
      };
    };
  in
    inputs.snowfall-lib.mkFlake {
      inherit inputs self;
      src = ./.;
      snowfall.namespace = "nix-homelab";
      channels-config.allowUnfree = true;

      apps = inputs.nixinate.nixinate.x86_64-linux self;

      systems = {
        modules.nixos = with inputs; [
          ./share/all
        ];
        hosts = {
          nix-hypervisor = {
            modules = with inputs; [
              microvm.nixosModules.host
              home-manager.nixosModules.home-manager
              impermanence.nixosModules.impermanence
              sops-nix.nixosModules.sops
              ./share/physical/nixos
            ];
            specialArgs = {
              inherit self properties;
            };
          };
          nix-nas = {
            modules = with inputs; [
              home-manager.nixosModules.home-manager
              impermanence.nixosModules.impermanence
              sops-nix.nixosModules.sops
              ./share/physical/nixos
            ];
            specialArgs = {
              inherit self properties;
            };
          };
          micro-media = microvms;
          micro-server = microvms;
          micro-infra = microvms;
          micro-tailscale = microvms;
          micro-download = microvms;
          micro-automate = microvms;
        };
      };
      homes.users = {
        "raab@nix-hypervisor".modules = with inputs; [
          impermanence.nixosModules.home-manager.impermanence
          ./share/physical/home
        ];
        "raab@nix-nas".modules = with inputs; [
          impermanence.nixosModules.home-manager.impermanence
          ./share/physical/home
        ];
      };
    };
}
