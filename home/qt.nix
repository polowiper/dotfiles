{pkgs, ...}:

{
  qt = {
    enable = true;
    platformTheme = "qtct";
    style = {
      package = pkgs.catppuccin-qt5ct;
      name = "catppuccin";
    };
  };


}
