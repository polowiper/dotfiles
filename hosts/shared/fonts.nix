{pkgs, config, ...}: {
  fonts = {
    packages = [
      pkgs.nerd-fonts.monaspace
      pkgs.nerd-fonts.jetbrains-mono
    ];
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = rec {
        monospace = ["${config.var.fontName} Mono"];
        sansSerif = ["${config.var.fontName}"];
        serif = sansSerif;
      };
    };
  };
}

#Here my fontName Monaspice Nerd Font
