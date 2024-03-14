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
    deploy-rs.url = "github:serokell/deploy-rs";
  };
  outputs = inputs: let
    self = inputs.self;
    properties = import (self + /assets/properties);
    microvm-config = {
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

      systems = {
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
      };

      #TODO deploy microvm?
      deploy.nodes = {
        nix-nas = {
          hostname = "nix-nas";
          interactiveSudo = true;
          profiles = {
            system = {
              sshUser = "raab";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nix-nas;
              user = "root";
              remoteBuild = true;
            };
          };
        };
        nix-hypervisor = {
          hostname = "nix-hypervisor";
          interactiveSudo = true;
          profiles = {
            system = {
              sshUser = "raab";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nix-hypervisor;
              user = "root";
              remoteBuild = true;
            };
          };
        };
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
    };
}
