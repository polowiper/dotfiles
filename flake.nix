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

     hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
     split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
     };
     
     nixvim = {
      url = "github:nix-community/nixvim";
      #inputs.nixpkgs.follows = "nixpkgs";   lmao it broke and I don't wanna wait for the fix to be merged 
     };

     spicetify-nix.url = "github:the-argus/spicetify-nix";
 };

  outputs = {
    self, 
    nixpkgs,
    home-manager,
    ... 
    } @ inputs: let
      inherit (import ./system/options.nix) hostName system;
      inherit (import ./home/options.nix) userName;
      pkgs = nixpkgs.legacyPackages.${system};
    in {
    nixosConfigurations."${hostName}" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./system/configuration.nix
      ];
     
    };

    homeConfigurations."${userName}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs;};
      modules = [
        ./home/home.nix
      ];
    };
  };
}
