# Hyprpaper is used to set the wallpaper on the system
{
  lib,
  config,
  pkgs,
  ...
}: {
  # The wallpaper is set by stylix
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;

      # Explicitly set preload and wallpaper with monitor names
      preload = lib.mkForce ["${config.stylix.image}"];

      # This stupid thing breaks every now and then because SOMEHOW it can't respect simple casing
      # wallpaper = lib.mkForce [
      #   "eDP-1,${config.stylix.image}"
      #   "DP-3,${config.stylix.image}"
      #   "DP-4,${config.stylix.image}"
      # ];
      extraConfig = ''
        wallpaper = eDP-1,${config.stylix.image}
        wallpaper = DP-3,${config.stylix.image}
        wallpaper = DP-4,${config.stylix.image}
      '';
    };
  };
  systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
}
