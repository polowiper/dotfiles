{...}: {
  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
}
