{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    mkHost = host: system: {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/${host}/configuration.nix
        ];
      };
    };

    sharedHome = system:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs;};
        modules = [./home/home.nix];
      };
  in {
    nixosConfigurations = {
      andromeda = (mkHost "andromeda" "x86_64-linux").nixos;
      sagittarius = (mkHost "sagittarius" "x86_64-linux").nixos;
    };

    homeConfigurations = {
      "polo@andromeda" = sharedHome "x86_64-linux";
      "polo@sagittarius" = sharedHome "x86_64-linux";
    };
  };
}
