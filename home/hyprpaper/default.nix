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
    # Use 0.7.x - 0.8.1 has a known DMA-BUF hang bug
    package = pkgs.hyprpaper.overrideAttrs (oldAttrs: rec {
      version = "0.7.6";
      src = pkgs.fetchFromGitHub {
        owner = "hyprwm";
        repo = "hyprpaper";
        rev = "v${version}";
        hash = "sha256-l/OxM4q/nLVv47OuS4bG2J7k0m+G7/3AMtvrV64XLb0=";
      };
    });
    settings = {
      ipc = "on";
      splash = false;

      # Explicitly set preload and wallpaper with monitor names
      preload = lib.mkForce ["${config.stylix.image}"];
      wallpaper = lib.mkForce [
        "eDP-1,${config.stylix.image}"
        "DP-3,${config.stylix.image}"
        "DP-4,${config.stylix.image}"
      ];
    };
  };
  systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
}
