# Standalone Home Manager configurations, one per machine/user.
#
# These intentionally mirror the system configurations so `home-manager switch`
# keeps working without root. Phase 5 makes the per-host entrypoints diverge.
{inputs, ...}: {
  flake.homeConfigurations = {
    "polo@andromeda" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {inherit inputs;};
      modules = [
        ../hosts/andromeda/home.nix
        inputs.stylix.homeModules.stylix
      ];
    };
    "polo@sagittarius" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {inherit inputs;};
      modules = [
        ../hosts/sagittarius/home.nix
        inputs.stylix.homeModules.stylix
      ];
    };
  };
}
