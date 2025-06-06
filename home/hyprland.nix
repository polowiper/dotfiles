{
  pkgs,
  inputs,
  ...
}:
# The wallpaper will be fetched from GitHub. I don't store my wallpapers locally.
let
  currentWallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/polowiper/Wallpapers/main/anime-girl.jpg";
    sha256 = "sha256-/lo8Spx7wJcdMP0HQBAzwO9ytpng2VjkCaUGf7b7Chc=";
  };
  hyprpaperConf = pkgs.writeText "hyprpaper.conf" ''
    preload = ${currentWallpaper}
    wallpaper = ,${currentWallpaper}
    splash = false
  '';
  inherit (import ./scripts.nix {inherit pkgs;}) batteryNotificationScript rofiPowerMenuScript rofiWifiMenuScript screenshotScript wifi-menu rofi-menu power-menu;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    systemd = {
      enable = true;
      variables = ["--all"];
    };
    plugins = [
    ];
    settings = {
      general = {
        layout = "dwindle";
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "0x9399b2FF";
        "col.inactive_border" = "0x4488a3EE";
      };

      monitor = [
        "eDP-1, 1920x1080@60.01, 1920x0, 1"
        "HDMI-A-1, preferred, 0x0, 1"
        #"HDMI-A-1, 1920x1080@144.00, 0x0, 1"
        "DP-3, preferred, -1080x0, 1, transform, 1"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "intl";
        touchpad = {
          natural_scroll = false;
          disable_while_typing = false;
        };

        repeat_rate = 40;
        repeat_delay = 250;
        force_no_accel = true;
        sensitivity = 0; # -1.0 - 1.0, 0 = no modification.
        follow_mouse = 1;
        numlock_by_default = true;
      };

      misc = {
        enable_swallow = true;
        force_default_wallpaper = 0;
        new_window_takes_over_fullscreen = 2;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
      };

      windowrule = [
        "float,title:^(udiskie)$"
        "float,title:^(Transmission)$"
        "float,title:^(Volume Control)$"
        "size 700 450,title:^(Volume Control)$"
        "size 700 450,title:^(Save As)$"
        "float,title:^(Library)$"
        "size 700 450,title:^(Page Info)$"
        "float,title:^(Page Info)$"
      ];
      windowrulev2 = [
        "float,class:^(Thunar)$"
        "size 70% 70%,class:^(Thunar)$"
        "float,class:^(thunar)$" #HALF OF THE FUCKING TIME THE CLASS NAME IS Thunar AND THE OTHER HALF OF THE TIME IT'S thunar, I'M TIRED OF CHANGING THAT EVERY SINGLE FUCKING TIME SO FUCK YOU
        "size 70% 70%,class:^(thunar)$"
        "float,class:^(org.gnome.Loupe)$"
        "size 70% 70%,class:^(org.gnome.Loupe)$"
        "float,class:^(pavucontrol)$"
        "float,class:^(file_progress)$"
        "float,class:^(confirm)$"
        "float,class:^(io.github.kaii_lb.Overskride)$"
        "float,class:^(dialog)$"
        "float,title:^(Please wait...)$"
        "size 70% 70%,class:^(Please wait...)$"
        "float,title:^(IDA: Quick start)$"
        "size 70% 70%,class:^(IDA: Quick start)$"
        "float,title:^(About)$"
        "size 70% 70%,class:^(About)$"
        "float,class:^(download)$"
        "float,class:^(notification)$"
        "float,class:^(nm-connection-editor)$"
        "float,title:^(File Operation Progress)$"
        "float,title:^(Open File)$"
        "float,title:^(Save As)$"
      ];

      decoration = {
        rounding = 7;
        #`"col.shadow" = "rgba(1a1a1aee)";
        active_opacity = 1.0; #The transparent era is over :sadge:
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;
        blur = {
          enabled = true;
          size = 4;
          passes = 2;

          brightness = 1;
          contrast = 1.3;
          ignore_opacity = true;
          noise = 1.17e-2;

          new_optimizations = true;
          xray = true;
        };
      };

      animations = {
        enabled = true;
        first_launch_animation = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      dwindle = {
        preserve_split = true;
        smart_split = true;
      };
      gestures.workspace_swipe = true;

      # Using the Super key (windows button) as the main mod.
      "$mainMod" = "SUPER";

      bind =
        [
          # Launch apps
          "$mainMod,        f,   exec,   ${pkgs.firefox-esr}/bin/firefox-esr"
          "$mainMod,        i,   exec,   ${pkgs.loupe}/bin/loupe"
          "$mainMod,        p,   exec,   ${power-menu}/bin/powermenu"
          "$mainMod,        w,   exec,   ${wifi-menu}/bin/script"
          "$mainMod,        d,   exec,   ${pkgs.xfce.thunar}/bin/thunar"
          "$mainMod,        q,   exec,   ${rofi-menu}/bin/rofi-menu"
          "$mainMod,        y,   exec,   spotify"
          "$mainMod,        x,   exec,   hyprlock" # Make sure you have Hyprlock installed. There's an official flake for it. See /flake.nix
          "$mainMod,        t,   exec,   ${pkgs.kitty}/bin/kitty"
          "$mainMod SHIFT,  b,   exec,   ${batteryNotificationScript}/bin/script"
          "$mainMod SHIFT,  s,   exec,   ${screenshotScript}/bin/script"

          # Control media players.
          ",XF86AudioPlay,  exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ",XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ",XF86AudioNext,  exec, ${pkgs.playerctl}/bin/playerctl next"
          ",XF86AudioPrev,  exec, ${pkgs.playerctl}/bin/playerctl previous"

          # Close a window or quit Hyprland.
          "$mainMod, C, killactive,"
          "$mainMod SHIFT, M, exit,"

          # Toggle window states.
          "$mainMod SHIFT, v, togglefloating,"
          "$mainMod, Shift_R, fullscreen,"

          # Toggle special workspace
          "$mainMod, S, togglespecialworkspace"

          # Move focus from one window to another.
          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"

          # Move window to either the left, right, top, or bottom.
          "$mainMod SHIFT,  h, movewindow, l"
          "$mainMod SHIFT,  l, movewindow, r"
          "$mainMod SHIFT,  k, movewindow, u"
          "$mainMod SHIFT,  j, movewindow, d"
        ]
        # WTF is this? I don't understand Nix code. 😿
        ++ map (n: "$mainMod SHIFT, ${toString n}, movetoworkspace, ${
          toString (
            if n == 0
            then 10
            else n
          )
        }") [1 2 3 4 5 6 7 8 9 0]
        ++ map (n: "$mainMod, ${toString n}, workspace, ${
          toString (
            if n == 0
            then 10
            else n
          )
        }") [1 2 3 4 5 6 7 8 9 0];

      binde = [
        # Move windows.
        "$mainMod SHIFT, h, moveactive, -20 0"
        "$mainMod SHIFT, l, moveactive, 20 0"
        "$mainMod SHIFT, k, moveactive, 0 -20"
        "$mainMod SHIFT, j, moveactive, 0 20"

        # Control the volume.
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute,        exec, wpctl set-mute   @DEFAULT_AUDIO_SINK@ toggle"

        # Control the brightness
        "$mainMod ,XF86AudioRaiseVolume, exec, brightnessctl s 5%+"
        "$mainMod ,XF86AudioLowerVolume, exec, brightnessctl s 5%-"
        "         ,XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        "         ,XF86MonBrightnessUp, exec, brightnessctl s 5%+"

        # Resize windows.
        "$mainMod CTRL, l, resizeactive, 30 0"
        "$mainMod CTRL, h, resizeactive, -30 0"
        "$mainMod CTRL, k, resizeactive, 0 -10"
        "$mainMod CTRL, j, resizeactive, 0 10"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging.
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      plugin = {
        hyprsplit = {
          num_workspaces = 10;
        };
      };
      exec-once = [
        "${pkgs.hyprpaper}/bin/hyprpaper -c ${hyprpaperConf}"
        "${pkgs.waybar}/bin/waybar"

        # Please see home/gtk.nix before modifying the line below. It actually sets the cursor to Bibata-Modern-Ice.
        "hyprctl setcursor Borealis-cursors 24"
      ];
    };
  };
}
