# GNOME session. Only imported by machines that actually run GNOME.
{pkgs, ...}: {
  services.desktopManager.gnome.enable = true;

  # To disable installing GNOME's suite of applications
  # and only be left with GNOME shell.
  services.gnome.core-apps.enable = true;
  services.gnome.core-developer-tools.enable = true;
  services.gnome.games.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];
}
