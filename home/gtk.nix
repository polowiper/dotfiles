{
  pkgs,
  lib,
  config,
  ...
}: {
  home.sessionVariables = {
    GTK_THEME = "adw-gtk3";
    GTK_USE_PORTAL = "1";
    GDK_BACKEND = "wayland";
  };
  /*
           home.pointerCursor = {
      name = "Borealis-cursor";
      package = pkgs.borealis-cursors;
      size = 32;
      gtk.enable = true;
  };
  */
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Borealis-cursors";
      package = pkgs.borealis-cursors;
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    gtk2 = {
      configLocation = "${config.var.homeDir}/gtk-2.0/gtkrc";
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
    };
  };
}
