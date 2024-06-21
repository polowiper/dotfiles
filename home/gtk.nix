{pkgs, ...}:  

{
  home.sessionVariables = {
    GTK_THEME = "rose-pine-gtk-theme-unstable";
      GTK_USE_PORTAL = "1";
  };
  
  gtk = {
    enable = true;
    theme = {
      name = "rose-pine-gtk-theme-unstable";
      package = pkgs.rose-pine-gtk-theme;
     };
    cursorTheme.name = "default";
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "pink";
      };
      name = "Papirus-Dark";
    };
  };
}
