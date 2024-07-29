{pkgs, inputs, ...}:


{

imports = [inputs.spicetify-nix.homeManagerModules.default];
programs.spicetify =
   let
     spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
   in
   {
     enable = true;
     spotifyPackage = pkgs.spotify;
     theme = spicePkgs.themes.catppuccin;
     colorScheme = "mocha";   
      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
        loopyLoop
        popupLyrics
      ];
  };
}
