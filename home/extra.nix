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

    bambu-studio # GOT A FUCKING 3D PRINTER LET'S GOOOOOOOOOOOOOO
    droidcam
    freecad # Waiting for the pagmo2 fix to be merged into unstable

    #Fpga card
    quartus-prime-lite
    openfpgaloader

    #Wii stuff
    wiimms-iso-tools
    rvz

    #Steam stuff
    wine64
    winetricks
    protontricks

    gimp
    feh
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
    inputs.pwndbg.packages.${pkgs.system}.default
    gdb

    # Poc (for serious programming I use devshells
    python311
    libgcc
    gnumake

    kicad
    zathura
    texlive.combined.scheme-basic
    imagemagick
    sqlite
    overskride
    oversteer
    quarto

    # 1337
    monero-gui
    mullvad-vpn
    hexchat
    bitwarden-desktop

    kdePackages.okular
    lorien

    # Minecraft
    temurin-bin
    prismlauncher

    loupe
    grim
    swappy
    wine-wayland
    slurp
    mpv-unwrapped
    anydesk

    # Coding ish stuff (I say ish because most of the coding shit is in devshells)
    man
    man-pages
    clang-manpages

    nix-inspect
    nix-prefetch-scripts
  ];
}
