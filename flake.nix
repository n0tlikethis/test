{
  description = "pain";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    home-manager.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/NUR";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs systems;
    systems = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      rhine = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs home-manager;};
        modules = [
          home-manager.nixosModule
          ./hosts/rhine/configuration.nix
        ];
      };
    };
    
    home-manager = home-manager.packages.${nixpkgs.system}."home-manager";

    homeConfigurations = {
      dann = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs home-manager self;};
        modules = [
          ./home/dann/home.nix
        ];
      };
    };

    rhine = self.nixosConfigurations.rhine.config.system.build.toplevel;
  };
}
