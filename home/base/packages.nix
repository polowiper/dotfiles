# Generic CLI tools and system/browser utilities.
{pkgs, ...}: {
  home.packages = with pkgs; [
    # Networking
    inetutils
    wireguard-tools
    wireguard-ui
    networkmanagerapplet
    networkmanager-openvpn
    networkmanager-libreswan

    # Misc
    usbguard
    xev
    imagemagick

    # Docs / nix tooling
    man
    man-pages
    clang-manpages
    nix-inspect
    nix-prefetch-scripts
  ];
}
