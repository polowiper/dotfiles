{
  pkgs,
  lib,
  ...
}: let
  # GNOME equivalents for the Hyprland binds in ./hyprland/bindings.nix.
  # GNOME-native actions are used wherever one exists: app view (wofi),
  # quick settings (better-control), screenshot UI (swappy), lock, logout,
  # close and workspaces. Only the app launches that have no GNOME
  # counterpart stay as custom commands.
  # Things GNOME has no concept of (directional focus/move/resize via
  # Super + h/j/k/l, Super + Ctrl + h/j/k/l, and the Super + s scratchpad)
  # cannot be matched and are intentionally left alone.
  customBindings = [
    {
      name = "Firefox";
      command = "${pkgs.firefox}/bin/firefox";
      binding = "<Super>f";
    }
    {
      name = "Files";
      command = "${pkgs.thunar}/bin/thunar";
      binding = "<Super>d";
    }
    {
      name = "Image Viewer";
      command = "${pkgs.loupe}/bin/loupe";
      binding = "<Super>i";
    }
    {
      name = "Terminal";
      command = "${pkgs.kitty}/bin/kitty";
      binding = "<Super>t";
    }
    # Hyprland maps Super + the volume keys to brightness; GNOME has no
    # native binding for that combination.
    {
      name = "Brightness Up";
      command = "${pkgs.brightnessctl}/bin/brightnessctl s 5%+";
      binding = "<Super>XF86AudioRaiseVolume";
    }
    {
      name = "Brightness Down";
      command = "${pkgs.brightnessctl}/bin/brightnessctl s 5%-";
      binding = "<Super>XF86AudioLowerVolume";
    }
  ];
  customPath = i: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString i}/";
  customSettings = lib.listToAttrs (lib.imap0 (i: c: {
    name = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString i}";
    value = {inherit (c) name command binding;};
  }) customBindings);
  # Hyprland defines workspaces 1-9.
  workspaces = lib.range 1 9;
in {
  dconf.settings = customSettings // {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

    # Fixed 1-9 workspaces, like Hyprland, instead of GNOME's dynamic ones.
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 9;
    };

    # Native lock (hyprlock) and logout (exit).
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = lib.imap0 (i: _: customPath i) customBindings;
      screensaver = ["<Super>x"];
      logout = ["<Super><Shift>m"];
    };

    # wofi -> app view, better-control -> quick settings, swappy -> screenshot
    # UI. Super + <n> must stop launching apps so it can switch workspaces.
    "org/gnome/shell/keybindings" =
      {
        toggle-application-view = ["<Super>q"];
        toggle-quick-settings = ["<Super>z"];
        show-screenshot-ui = ["<Super>r"];
      }
      // lib.listToAttrs (map (n: {
        name = "switch-to-application-${toString n}";
        value = [];
      }) workspaces);

    "org/gnome/desktop/wm/keybindings" =
      {
        close = ["<Super>c"];
        toggle-above = ["<Super><Shift>v"]; # closest thing to togglefloating
      }
      // lib.listToAttrs (lib.concatMap (n: [
        {
          name = "switch-to-workspace-${toString n}";
          value = ["<Super>${toString n}"];
        }
        {
          name = "move-to-workspace-${toString n}";
          value = ["<Super><Shift>${toString n}"];
        }
      ]) workspaces);
  };
}
