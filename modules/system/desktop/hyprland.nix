# System-level Hyprland session (the compositor itself is configured in Home Manager).
{...}: {
  programs.hyprland = {
    enable = true;
  };
}
