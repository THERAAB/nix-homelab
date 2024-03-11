{
  description = "nix-homelab flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
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
    nixinate.url = "github:matthewcroughan/nixinate";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    impermanence,
    sops-nix,
    microvm,
    nixinate,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  in {
    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./share/lib/pkgs {inherit pkgs;}
    );
    # Devshell for bootstrapping
    # Acessible through 'nix develop' or 'nix-shell' (legacy)
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./share/shell.nix {inherit pkgs;}
    );
    # Your custom packages and modifications, exported as overlays
    overlays = import ./share/lib/overlays;
    apps = nixinate.nixinate.x86_64-linux self;
    nixosConfigurations = {
      nix-hypervisor = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs self;};
        modules = [
          impermanence.nixosModules.impermanence
          ./share/lib/modules/nixos/olivetin
          ./share/physical/nixos
          ./share/all
          ./hosts/nix-hypervisor
          sops-nix.nixosModules.sops
          microvm.nixosModules.host
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.raab = {pkgs, ...}: {
                imports = [
                  impermanence.nixosModules.home-manager.impermanence
                  ./share/physical/home
                ];
              };
            };
            _module.args.nixinate = {
              host = "nix-hypervisor";
              sshUser = "raab";
              buildOn = "remote";
              substituteOnTarget = true;
              hermetic = false;
            };
          }
        ];
      };
      nix-nas = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          impermanence.nixosModules.impermanence
          ./share/physical/nixos
          ./hosts/nix-nas
          ./share/all
          sops-nix.nixosModules.sops

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.raab = {pkgs, ...}: {
                imports = [
                  impermanence.nixosModules.home-manager.impermanence
                  ./share/physical/home
                ];
              };
            };
            _module.args.nixinate = {
              host = "nix-nas";
              sshUser = "raab";
              buildOn = "remote";
              substituteOnTarget = true;
              hermetic = false;
            };
          }
        ];
      };
    };
  };
}
