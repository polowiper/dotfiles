{pkgs, ...}: {
  wayland.windowManager.hyprland.settings = {
    # Using the Super key (windows button) as the main mod.
    "$mainMod" = "SUPER";

    bind =
      [
        # Launch apps
        "$mainMod,        f,   exec,   ${pkgs.firefox}/bin/firefox"
        "$mainMod,        q,   exec,   ${pkgs.wofi}/bin/wofi"
        "$mainMod,        i,   exec,   ${pkgs.loupe}/bin/loupe"
        "$mainMod,        d,   exec,   ${pkgs.xfce.thunar}/bin/thunar"
        "$mainMod,        r,   exec,   screenshot region swappy"
        "$mainMod,        x,   exec,   hyprlock" # Make sure you have Hyprlock installed. There's an official flake for it. See /flake.nix
        "$mainMod,        t,   exec,   ${pkgs.kitty}/bin/kitty"

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
        "$mainMod SHIFT,  s,   movetoworkspace, special"

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
      ++ (builtins.concatLists (
        builtins.genList (
          i: let
            ws = i + 1;
          in [
            "$mainMod,code:1${toString i}, workspace, ${toString ws}"
            "$mainMod SHIFT,code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        )
        9
      ));

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
  };
}
