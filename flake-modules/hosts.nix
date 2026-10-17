# NixOS system configurations, one per machine.
{inputs, ...}: {
  flake.nixosConfigurations = {
    andromeda = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ../hosts/andromeda/configuration.nix
        inputs.stylix.nixosModules.stylix
      ];
    };
    sagittarius = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ../hosts/sagittarius/configuration.nix
        inputs.stylix.nixosModules.stylix
      ];
    };
  };
}
