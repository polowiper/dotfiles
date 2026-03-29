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
        # "DP-3, 1920x1080@144.00, 0x0, 1" # Main screen (external) but when I am back at home
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
      };

      windowrule = [
        # Modal windows
        "match:tag modal, float true, pin true, center true"

        # Telegram media viewer
        "match:title Media viewer, float true"

        # Bitwarden extension
        "match:title .*Bitwarden Password Manager.*, float true"

        # GNOME Calculator
        "match:class org.gnome.Calculator, float true"
        "match:class org.gnome.Calculator, size 360 490"

        # Thunar (case-insensitive)
        "match:class [Tt]hunar, float true"
        "match:class [Tt]hunar, size 70% 70%"

        # GNOME Image Viewer
        "match:class org.gnome.Loupe, float true"
        "match:class org.gnome.Loupe, size 70% 70%"

        # Firefox/Zen Picture-in-Picture
        "match:title Picture-in-Picture, float true, pin true"

        # Random floating windows
        "match:class pavucontrol, float true"
        "match:class file_progress, float true"
        "match:class confirm, float true"
        "match:class io.github.kaii_lb.Overskride, float true"
        "match:class dialog, float true"
        "match:title Please wait..., float true"
        "match:title Please wait..., size 70% 70%"
        "match:title IDA: Quick start, float true"
        "match:title IDA: Quick start, size 70% 70%"
        "match:title About, float true"
        "match:title About, size 70% 70%"
        "match:class download, float true"
        "match:class notification, float true"
        "match:class nm-connection-editor, float true"
        "match:title File Operation Progress, float true"
        "match:title Open File, float true"
        "match:title Save As, float true"
        "match:class xdg-desktop-portal-gtk, float true"
        "match:class .scrcpy-wrapped, float true"

        # Idle inhibit while watching videos
        "match:class mpv, idle_inhibit focus"
        "match:class celluloid, idle_inhibit focus"
        "match:class .+exe, idle_inhibit focus"
        "match:class firefox, match:title YouTube, idle_inhibit focus"

        # Dim around certain windows
        "match:class gcr-prompter, dim_around true"
        "match:class xdg-desktop-portal-gtk, dim_around true"
        "match:class polkit-gnome-authentication-agent-1, dim_around true"
        "match:class firefox, match:title File Upload, dim_around true"

        # JetBrains windows
        "match:class .*jetbrains.*, match:title Confirm Exit|Open Project|win424|win201|splash, center true"
        "match:class .*jetbrains.*, match:title splash, size 640 400"
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
