{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.libnotify];

  services.mako = {
    settings = {
      enable = true;
      margin = "0,20,20";
      padding = "10";
      borderSize = 2;
      borderRadius = 5;
      defaultTimeout = 10000;
      groupBy = "summary";
      iconPath = "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark";
    };
  };
}
