{pkgs, ...}: let
  inherit (import ./options.nix) fontName;
in {
  # List packages installed in system profile. To search, run:
  # $ nix search wgetcon
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wl-clipboard
    wget
    git
    direnv
    kitty
    firefox
    nh
    xwayland
    zip
    unzip
    helvum
    via
    qmk
    qemu
    parted
    gvfs # Thunar dep
    brightnessctl
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      font = fontName;
      fontSize = "9";
      background = "${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/polowiper/Wallpapers/main/AnimeWaiting.png";
        sha256 = "sha256-BLSly9FQWaW27oMWH4g3YNHKcbczQgUNZrYUeYJSkTA=";
      }}";
      loginBackground = true;
    })
  ];
  programs.dconf.enable = true; # gnome
  programs.xfconf.enable = true; # xfce

  # Qemu shit
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["polo"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # thunar
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-media-tags-plugin
    ];
  };
  programs.kdeconnect.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
