{config, lib, ...}: {
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };

  config.var = {
    # system/locale.nix
    theLocale = "en_US.UTF-8";
    theTimeZone = "Europe/Paris";

    system = "x86_64-linux";

    # system/fonts.nix + various UI components
    fontName = "Monaspice Nerd Font";
    
    # User settings (needed for users.nix and home-manager)
    userName = "polo";
    userFullName = "polo";
  };
}
