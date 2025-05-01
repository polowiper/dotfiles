{pkgs, ...}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wgetcon
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wl-clipboard
    wget
    git
    direnv
    nh
    xwayland
    zip
    unzip
    helvum
    via
    qmk
    brightnessctl
  ];
programs.dconf.enable = true; # gnome
  programs.xfconf.enable = true; # xfce

  # thunar
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-media-tags-plugin
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
