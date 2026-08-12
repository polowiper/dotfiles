{
  pkgs,
  lib,
  inputs,
  ...
}: {
  nixpkgs.config.android_sdk.accept_license = true;
  home.packages = with pkgs; [
    osu-lazer

    vial
    obs-studio
    xev
    kotatogram-desktop # tg
    karere # whatsapp
    onlyoffice-desktopeditors

    orca-slicer # GOT A FUCKING 3D PRINTER LET'S GOOOOOOOOOOOOOO
    droidcam
    freecad # Waiting for the pagmo2 fix to be merged into unstable

    #STM32
    stm32cubemx
    stm32loader
    stlink
    stlink-tool
    (lib.lowPrio gcc-arm-embedded)
    (lib.lowPrio openocd)
    screen
    picocom
    platformio-core

    #Networking
    inetutils
    wireguard-tools
    wireguard-ui
    networkmanagerapplet
    networkmanager-openvpn
    networkmanager-vpnc

    #Fpga card
    graphviz
    yosys
    quartus-prime-lite
    openfpgaloader
    picoscope

    #Wii stuff
    wiimms-iso-tools
    rvz

    #Steam stuff
    wine64
    winetricks
    protontricks

    gimp
    feh
    better-control
    usbguard
    deluge
    graphviz
    sqlitestudio

    #Modding
    hcli
    scrcpy
    android-tools
    apktool
    ghex
    httptoolkit-server
    httptoolkit
    wireshark
    ripgrep
    inputs.pwndbg.packages.${pkgs.stdenv.hostPlatform.system}.default
    gdb

    # Poc (for serious programming I use devshells
    python311
    libgcc
    gnumake

    kicad
    scilab-bin
    zathura
    texlive.combined.scheme-basic
    imagemagick
    sqlite
    overskride
    oversteer
    quarto
    qalculate-gtk
    gnuplot

    # 1337
    monero-gui
    mullvad-vpn
    #bitwarden-desktop # Fucking electron is marked as insecure so fuck you

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
