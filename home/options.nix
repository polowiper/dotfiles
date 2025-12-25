{
  config,
  lib,
  ...
}: {
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };

  config.var = rec {
    # User settings
    userName = "polo";
    userFullName = "polo";

    # Git settings
    gitUserName = "polowiper";
    gitEmail = "53773040+polowiper@users.noreply.github.com";

    # Paths
    homeDir = "/home/${userName}";
    dotfilesDir = "/home/${userName}/nixos";

    # UI settings
    fontName = "Monaspice Nerd Font";
    location = "";
  };
}
