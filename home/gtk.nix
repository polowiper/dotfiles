{pkgs, lib, ...}:

let
extraCss = ''
@define-color accent_bg_color #c4a7e7;
@define-color accent_fg_color #191724;
@define-color accent_color #c4a7e7;

@define-color destructive_bg_color #eb6f92;
@define-color destructive_fg_color #191724;
@define-color destructive_color #eb6f92;

@define-color dialog_bg_color #26233a;
@define-color dialog_fg_color #e0def4;

@define-color sidebar_bg_color #191724;
@define-color sidebar_fg_color #e0def4;
@define-color sidebar_backdrop_color #191724;
@define-color sidebar_shade_color #191724;

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
@define-color headerbar_border_color #191724;
@define-color headerbar_shade_color #191724;

@define-color card_bg_color #1f1d2e;
@define-color card_fg_color #e0def4;
@define-color card_shade_color #1f1d2e;

@define-color popover_bg_color #26233a;
@define-color popover_fg_color #e0def4;

'';
inherit (import ./options.nix) homeDir;
in {
  home.sessionVariables = {
  GTK_THEME = "adw-gtk3";
  GTK_USE_PORTAL = "1";
  GDK_BACKEND = "wayland";
  };
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
    gtk2 = {
      configLocation = "${homeDir}/gtk-2.0/gtkrc";
      extraConfig = ''
      '';
    };

    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-overlay-scrolling = false;
        gtk-enable-primary-paste = false;
        gtk-error-bell = false;
        gtk-enable-input-feedback-sounds = false;
        gtk-decoration-layout = "appmenu:none";
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
      };
      inherit extraCss;
    };

    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-overlay-scrolling = false;
        gtk-enable-primary-paste = false;
        gtk-error-bell = false;
        gtk-enable-input-feedback-sounds = false;
        gtk-decoration-layout = "appmenu:none";
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
      };
      inherit extraCss;
    };
  };
}


