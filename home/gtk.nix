{pkgs, lib, ...}:  

let 
gtkCss = ''
@define-color accent_bg_color #c4a7e7;
@define-color accent_fg_color #191724;
@define-color accent_color #c4a7e7;

@define-color destructive_bg_color #eb6f92; 
@define-color destructive_fg_color #191724;
@define-color destructive_color #eb6f92;

@define-color success_bg_color #9ccfd8;
@define-color success_fg_color #e0def4;
@define-color success_color #9ccfd8;

@define-color warning_bg_color #f6c177;
@define-color warning_fg_color #e0def4;
@define-color warning_color #f6c177;

@define-color error_bg_color #eb6f92;
@define-color error_fg_color #e0def4;
@define-color error_color #eb6f92;

@define-color window_bg_color #191724;
@define-color window_fg_color #e0def4;

@define-color view_bg_color #26233a;
@define-color view_fg_color #e0def4;

@define-color headerbar_bg_color #191724;
@define-color headerbar_fg_color #e0def4;
@define-color headerbar_backdrop_color @window_bg_color;
@define-color headerbar_shade_color #191724;


@define-color card_bg_color #1f1d2e;
@define-color card_fg_color #e0def4;
@define-color card_shade_color #1f1d2e;

@define-color popover_bg_color #26233a;
@define-color popover_fg_color #e0def4;''; 
in {
  home.sessionVariables.GTK_THEME = "adw-gtk3";
/*   home.pointerCursor = {
    name = "Borealis-cursor";
    package = pkgs.borealis-cursors;
    size = 32;
    gtk.enable = true;
}; */
  gtk = {
    enable = true; 
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
     };
    cursorTheme = {
      name = "Borealis-cursors";
      package = pkgs.borealis-cursors;
    };
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "pink";
      };
      name = "Papirus-Dark";
    };
  
  gtk4.extraConfig = {
    gtk-application-prefer-dark-theme = true;
  };
  gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = true;
  };
};
  xdg.configFile = {
    "gtk-3.0/gtk.css" = {
        text = lib.mkForce gtkCss;
        force = true;
    };
    "gtk-4.0/gtk.css" = {
        text = lib.mkForce gtkCss;
        force = true;
    };
  };

}
