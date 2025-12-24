# Hyprlock is a lockscreen for Hyprland
{
  config,
  lib,
  ...
}: let
  foreground = "rgba(${config.theme.textColorOnWallpaper}ee)";
  font = config.stylix.fonts.serif.name;
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        ignore_empty_input = true;
        hide_cursor = true;
      };

      background = {
        brightness = 0.7172;
      };

      label = [
        {
          # Day-Month-Date
          monitor = "";
          text = ''cmd[update:1000] echo -e "$(date +"%A, %B %d")"'';
          font_size = 28;
          position = "0, 490";
          halign = "center";
          valign = "center";
        }
        # Time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<span>$(date +"%I:%M")</span>"'';
          font_size = 160;
          position = "0, 370";
          halign = "center";
          valign = "center";
        }
        # USER
        {
          monitor = "";
          text = "    $USER";
          font_size = 18;
          position = "0, -180";
          halign = "center";
          valign = "center";
        }
      ];

      # INPUT FIELD
      input-field = lib.mkForce {
        size = "300, 60";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        fade_on_empty = false;
        placeholder_text = "<i>Enter Password</i>";
        position = "0, -250";
        halign = "center";
        valign = "center";
      };
    };
  };
}
