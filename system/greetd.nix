{pkgs, ...}:

{
  services.greetd = {
  enable = true;
  package = pkgs.greetd.tuigreet;
  settings = rec {
    initial_session = {
      command = "hyprland";
      user = "polo";
    };
    default_session = initial_session;
  };
};
}
