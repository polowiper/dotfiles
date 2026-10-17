# Shared `var` options used by both the NixOS and Home Manager evaluations.
# This replaces the previously duplicated home/options.nix + hosts/shared/options.nix.
{lib, ...}: {
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

    # Locale / system
    theLocale = "en_US.UTF-8";
    theTimeZone = "Europe/Paris";
    system = "x86_64-linux";
  };
}
