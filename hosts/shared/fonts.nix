{pkgs, ...}: let
  inherit (import ./options.nix) fontName;
in {
  fonts = {
    packages = [
      pkgs.nerd-fonts.monaspace
      pkgs.nerd-fonts.jetbrains-mono
    ];
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = rec {
        monospace = ["${fontName} Mono"];
        sansSerif = ["${fontName}"];
        serif = sansSerif;
      };
    };
  };
}

#Here my fontName Monaspice Nerd Font
