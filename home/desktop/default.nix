# Desktop environment: Hyprland stack, bar, launcher, terminal, theming, tools.
{...}: {
  imports = [
    ./dconf.nix
    ./hypridle
    ./hyprland
    ./hyprlock
    ./hyprpaper
    ./kitty.nix
    ./qt.nix
    ./wayle.nix
    ./wofi.nix
    ./packages.nix
  ];
}
