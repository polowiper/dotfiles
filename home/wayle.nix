{lib, ...}: {
  services.wayle = {
    enable = true;
    autoInstallDependencies = true;
    settings = {
      bar = {
        layout = [
          {
            monitor = "DP-4";
            show = true;
            left = [];
            center = [];
            right = [];
          }

          {
            monitor = "DP-3";
            show = true;
            left = [];
            center = [];
            right = [];
          }

          {
            monitor = "eDP-1";
            show = true;
            left = [];
            center = [];
            right = [];
          }
        ];
      };
      modules = {
        clock = {
          format = "%H:%M:%S";
          dropdown-show-seconds = true;
        };
        weather = {
          location = "Paris";
          units = "metric";
        };
      };
    };
  };

  # The generated `wayle.service` is pulled in by `graphical-session.target`,
  # which is also reached in a GNOME session, so guard it explicitly. Unlike
  # XDG_CURRENT_DESKTOP/XDG_SESSION_DESKTOP (forced to "Hyprland[:GNOME]" by
  # this config), `DESKTOP_SESSION` reflects the session chosen at login.
  # `lib.mkForce` is needed because the home-manager module already sets
  # `ConditionEnvironment = "WAYLAND_DISPLAY"`.
  systemd.user.services.wayle.Unit.ConditionEnvironment = lib.mkForce [
    "WAYLAND_DISPLAY"
    "!DESKTOP_SESSION=gnome"
  ];
}
