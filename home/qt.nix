{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      package = pkgs.catppuccin-qt5ct;
      name = "catppuccin";
    };
  };
}
