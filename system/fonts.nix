{pkgs, ...}:
let 
  inherit (import ./options.nix) fontName;
in {
  fonts = {
    fonts = with pkgs; [(nerdfonts.override { fonts = ["Monaspace"];})];
    enableDefaultPackages = true;
    fontconfig.defaultFonts = rec {
      monospace = ["${fontName} Mono"];
      sansSerif  = ["${fontName}"];
      serif = sansSerif;
    };
  };
}
