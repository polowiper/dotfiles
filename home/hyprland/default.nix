{
  pkgs,
  config,
  lib,
  ...
}: let
  border-size = config.theme.border-size;
  gaps-in = config.theme.gaps-in;
  gaps-out = config.theme.gaps-out;
  active-opacity = config.theme.active-opacity;
  inactive-opacity = config.theme.inactive-opacity;
  rounding = config.theme.rounding;
  blur = config.theme.blur;
  background = "rgb(" + config.lib.stylix.colors.base00 + ")";
in {
  imports = [
    ./animations.nix
    ./bindings.nix
    ./polkitagent.nix
  ];

  home.packages = with pkgs;
    [
      qt5.qtwayland
      qt6.qtwayland
      libsForQt5.qt5ct
      qt6Packages.qt6ct
      hyprshot
      hyprpicker
      swappy
      imv
      wf-recorder
      wlr-randr
      wl-clipboard
      brightnessctl
      gnome-themes-extra
      libva
      dconf
      wayland-utils
      wayland-protocols
      glib
      direnv
      meson
      # Additional packages needed for hyprpanel commands
      hyprsunset
      grimblast
      rofi
      # Apps referenced in keybindings
      spotify
    ]
    ++ (with (import ../scripts.nix {inherit pkgs;}); [
      caffeine
      night-shift
      menu
      screenshot-swappy
    ]);

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd = {
      enable = false;
      variables = [
        "--all"
      ]; # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
    };
    package = null;
    portalPackage = null;

    settings = {
      "$mainMod" = "SUPER";
      "$shiftMod" = "SUPER_SHIFT";

      exec-once = [
        "dbus-update-activation-environment --systemd --all &"
        "systemctl --user enable --now hyprpaper.service &"
      ];

      monitor = [
        "eDP-1, 2560x1600@165.00, 1920x0, 1" # Internal screen (framework only tho different for the thinkpad I'll have to modify that later on)
        # "HDMI-A-1, preferred, 0x0, 1"
        "DP-3, 1920x1080@144.00, 0x0, 1" # Main screen (external)
        "DP-3, 1920x1080@60.00, 0x0, 1" # Main screen (external) but when I am back at home
        "DP-4, preferred, -1080x0, 1, transform, 1" # Left screen (vertical)
        ",prefered,auto,1" # default
      ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
        "ANKI_WAYLAND,1"
        "DISABLE_QT5_COMPAT,0"
        "NIXOS_OZONE_WL,1"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM=wayland,xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "__GL_GSYNC_ALLOWED,0"
        "__GL_VRR_ALLOWED,0"
        "DISABLE_QT5_COMPAT,0"
        "DIRENV_LOG_FORMAT,"
        "WLR_DRM_NO_ATOMIC,1"
        "WLR_BACKEND,vulkan"
        "WLR_RENDERER,vulkan"
        "WLR_NO_HARDWARE_CURSORS,1"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
      ];

      cursor = {
        no_hardware_cursors = true;
        default_monitor = "eDP-1";
      };

      general = {
        resize_on_border = true;
        gaps_in = gaps-in;
        gaps_out = gaps-out;
        border_size = border-size;
        layout = "dwindle";
        "col.inactive_border" = lib.mkForce background;
      };

      dwindle = {
        preserve_split = true;
        smart_split = true;
      };

      decoration = {
        active_opacity = active-opacity;
        inactive_opacity = inactive-opacity;
        rounding = rounding;
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
        };
        blur = {
          enabled =
            if blur
            then "true"
            else "false";
          size = 18;
        };
      };

      master = {
        new_status = true;
        allow_small_split = true;
        mfact = 0.5;
      };

      gesture = "3, horizontal, workspace";

      misc = {
        vfr = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = true;
        focus_on_activate = true;
        new_window_takes_over_fullscreen = 2;
      };

      windowrulev2 = [
        "float, tag:modal"
        "pin, tag:modal"
        "center, tag:modal"
        # telegram media viewer
        "float, title:^(Media viewer)$"

        # Bitwarden extension
        "float, title:^(.*Bitwarden Password Manager.*)$"

        # gnome calculator
        "float, class:^(org.gnome.Calculator)$"
        "size 360 490, class:^(org.gnome.Calculator)$"

        # Thunar
        "float,class:^(Thunar)$"
        "size 70% 70%,class:^(Thunar)$"

        "float,class:^(thunar)$" # HALF OF THE FUCKING TIME THE CLASS NAME IS Thunar AND THE OTHER HALF OF THE TIME IT'S thunar, I'M TIRED OF CHANGING THAT EVERY SINGLE FUCKING TIME SO FUCK YOU
        "size 70% 70%,class:^(thunar)$"

        # gnome image viewer
        "float,class:^(org.gnome.Loupe)$"
        "size 70% 70%,class:^(org.gnome.Loupe)$"

        # make Firefox/Zen PiP window floating and sticky
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"

        #Random stuff
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

        "float,class:^(xdg-desktop-portal-gtk)$"

        # idle inhibit while watching videos
        "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
        "idleinhibit focus, class:^(zen)$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(zen)$"

        "dimaround, class:^(gcr-prompter)$"
        "dimaround, class:^(xdg-desktop-portal-gtk)$"
        "dimaround, class:^(polkit-gnome-authentication-agent-1)$"
        "dimaround, class:^(zen)$, title:^(File Upload)$"

        "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
        "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"
      ];

      layerrule = [
        "noanim, launcher"
        "noanim, ^ags-.*"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "intl";
        follow_mouse = 1;
        sensitivity = 0;
        repeat_delay = 250;
        repeat_rate = 40;
        numlock_by_default = true;

        touchpad = {
          natural_scroll = false;
        };
      };
    };
  };
}
