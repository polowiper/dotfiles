# Desktop session concerns shared by every graphical machine.
# GNOME is intentionally NOT imported here; only machines that run it import
# desktop/gnome.nix directly.
{...}: {
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./power.nix
    ./xserver.nix
    ./hyprland.nix
    ./thunar.nix
    ./kdeconnect.nix
    ./sddm.nix
    ./eduroam.nix
  ];

  programs.dconf.enable = true;
}
