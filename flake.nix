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
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: let
    self = inputs.self;
    properties = import (self + /assets/properties);
    microvm-config = {
      modules = with inputs; [
        microvm.nixosModules.microvm
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
          home-manager.nixosModules.home-manager
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
        ];
        hosts = {
          nix-hypervisor = {
            modules = with inputs; [
              microvm.nixosModules.host
            ];
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
          micro-media = microvm-config;
          micro-server = microvm-config;
          micro-infra = microvm-config;
          micro-tailscale = microvm-config;
          micro-download = microvm-config;
          micro-automate = microvm-config;
        };
      };
      homes.users = {
        "raab@nix-hypervisor".modules = with inputs; [
          impermanence.nixosModules.home-manager.impermanence
        ];
        "raab@nix-nas".modules = with inputs; [
          impermanence.nixosModules.home-manager.impermanence
        ];
        "raab@nix-desktop".modules = with inputs; [
          impermanence.nixosModules.home-manager.impermanence
        ];
        "raab@nix-zenbook".modules = with inputs; [
          impermanence.nixosModules.home-manager.impermanence
        ];
      };
    };
}
