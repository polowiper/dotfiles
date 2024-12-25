{pkgs, ...}:
let 
  inherit (import ./options.nix) fontName;
in {
  fonts = {
    packages = [
      pkgs.nerd-fonts.monaspace
    ];
    enableDefaultPackages = true;
    fontconfig.defaultFonts = rec {
      monospace = ["${fontName} Mono"];
      sansSerif  = ["${fontName}"];
      serif = sansSerif;
    };
  };
}
