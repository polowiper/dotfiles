{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.android_sdk.accept_license = true;
  home.packages = with pkgs; [
    vial
    obs-studio
    anki
    xorg.xev
    kotatogram-desktop
    onlyoffice-desktopeditors

    #bambu-studio # GOT A FUCKING 3D PRINTER LET'S GOOOOOOOOOOOOOO
    freecad

    #Wii stuff
    wiimms-iso-tools
    rvz

    #Steam stuff
    wine64
    winetricks
    protontricks

    gimp
    networkmanagerapplet
    better-control
    usbguard
    deluge
    graphviz
    sqlitestudio

    #Modding
    scrcpy
    android-tools
    apktool
    ghex
    httptoolkit-server
    httptoolkit
    ripgrep

    kicad
    zathura
    texlive.combined.scheme-basic
    imagemagick
    sqlite
    overskride
    oversteer
    quarto
    monero-gui
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
