{pkgs, ...}: {
  home.packages = with pkgs; [
    chromium # Only for webhid purposes I use firefox otherwise
    obs-studio
    feh
    zathura
    kdePackages.okular
    loupe
    mpv-unwrapped
  ];
}
