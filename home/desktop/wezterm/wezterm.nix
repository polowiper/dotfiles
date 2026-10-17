{pkgs, ...}: {
  #home.sessionVariables.TERMINAL = "wezterm";
  home.packages = with pkgs; [
    wezterm
  ];
  # home.file.".config/wezterm" = {
  #   source = ./wez;
  #   recursive = true;
  # };
}
