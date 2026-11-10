{
  description = "NixOS configuration for mellowcat";

  
inputs = {
  # Main repository: unstable
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  # Secondary repository: stable
  nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

  caelestia-shell = {
    url = "github:caelestia-dots/shell";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};


  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos/configuration.nix
          ./modules/home-manager.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
