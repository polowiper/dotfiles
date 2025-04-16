{pkgs, libs, inputs, ...}:
# Fetch the fontName variable from system/options.nix to determine which font to use.
let
  inherit (import ../system/options.nix) fontName;

  # TODO: Replace this with proper Catppuccin colors.
  placeholderAndTimeColor = "rgb(205, 214, 244)";
in {

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        disable_loading_bar = false;
        no_fade_in = false;
      };

        background = [
        {
          monitor = "";
          path = toString (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/polowiper/Wallpapers/main/cat_anime-girl.png";
          sha256 = "sha256-eghqCS3tLe7i8DzaKtzsMPgkXTBR/BGNOP264jFWfNY=";
          });
        }
      ];

      input-field = [
        {
          size = "300, 40";
          outline_thickness = 2;
          outer_color = "rgb(69, 71, 90)";
          inner_color = placeholderAndTimeColor;
          font_color = "rgb(127, 132, 156)";
          fade_on_empty = false;
          placeholder_text = "je suis un débiteur indébitable indébitablement indébité qui débite sur le beat en débitant des putains de bites !!";
          dots_spacing = 0.3;
          dots_center = true;
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          font_family = "${fontName}";
          font_size = 50;
          color = placeholderAndTimeColor;
          position = "0, 70";
          valign = "center";
          halign = "center";
        }
      ];
      };
  };
}

