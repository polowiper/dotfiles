{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    vial
    obs-studio
    anki
    xorg.xev
    kotatogram-desktop
    libreoffice

    bambu-studio # GOT A FUCKING 3D PRINTER LET'S GOOOOOOOOOOOOOO
    freecad

    #Wii stuff
    wiimms-iso-tools
    rvz

    #Steam stuff
    wine
    winetricks
    protontricks

    gimp
    networkmanagerapplet
    better-control
    usbguard
    scrcpy
    android-tools
    apktool
    ghex
    ripgrep
    httptoolkit-server
    httptoolkit
    deluge
    graphviz
    rpi-imager
    sqlitestudio

    kicad
    zathura
    texlive.combined.scheme-basic
    imagemagick
    sqlite
    overskride
    quarto
    mullvad-vpn
    galculator
    kdePackages.okular
    lorien
    bitwarden-desktop
    temurin-bin
    prismlauncher
    loupe
    grim
    swappy
    wine-wayland
    slurp
    mpv-unwrapped
    nix-inspect
    nix-prefetch-scripts
    anydesk
  ];
}
