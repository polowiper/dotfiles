{
  autoPatchelfHook,
  cairo,
  copyDesktopItems,
  python3,
  tree,
  dbus,
  fetchurl,
  fontconfig,
  freetype,
  glib,
  gtk3,
  lib,
  libdrm,
  libGL,
  libkrb5,
  libsecret,
  libsForQt5,
  libunwind,
  libxkbcommon,
  makeDesktopItem,
  makeWrapper,
  openssl,
  stdenv,
  xorg,
  zlib,
  ...
}:
stdenv.mkDerivation rec {
  pname = "ida-cracked";
  version = "v9.0";
  src = ./ida.run;
  icon = fetchurl {
    urls = [
      "https://web.archive.org/web/20221105181235im_/https://hex-rays.com/products/ida/news/8_1/images/icon_teams.png"
    ];
    hash = "sha256-gjb999iszr6gqlJJjMJ6mMU8EJHbOSgIdFfbgUx8hkM=";
  };

  desktopItem = makeDesktopItem {
    name = "ida-pro";
    exec = "ida64";
    icon = icon;
    comment = "IDA";
    desktopName = "IDA Pro";
    genericName = "Interactive Disassembler";
    categories = ["Development"];
    startupWMClass = "IDA";
  };

  desktopItems = [desktopItem];

  nativeBuildInputs = [
    tree
    makeWrapper
    copyDesktopItems
    autoPatchelfHook
    libsForQt5.wrapQtAppsHook
  ];

  # We just get a runfile in $src, so no need to unpack it.
  dontUnpack = true;

  # Add everything to the RPATH, in case IDA decides to dlopen things.
  runtimeDependencies = [
    python3
    cairo
    dbus
    fontconfig
    freetype
    glib
    gtk3
    libdrm
    libGL
    libkrb5
    libsecret
    libsForQt5.qtbase
    libunwind
    libxkbcommon
    openssl
    stdenv.cc.cc
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXau
    xorg.libxcb
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    zlib
  ];
  buildInputs = runtimeDependencies;

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/opt $out/share/applications

    # IDA depends on quite some things extracted by the runfile, so first extract everything
    # into $out/opt, then remove the unnecessary files and directories.
    IDADIR=$out/opt

    export XDG_DATA_HOME=$out/share

    # Invoke the installer with the dynamic loader directly, avoiding the need
    # to copy it to fix permissions and patch the executable.
    $(cat $NIX_CC/nix-support/dynamic-linker) $src \
      --mode unattended --prefix $IDADIR

    # python3 -c "print('this is a test and you should somehow see it')"
    tree $out
    # Copy the exported libraries to the output.
    cd $out/opt/
    cp ${./keygen.py} $out/opt/keygen.py
    python3 $out/opt/keygen.py
    cd -

    mv $out/opt/libida.so.patched $out/opt/libida.so
    mv $out/opt/libida32.so.patched $out/opt/libida32.so

    cp $IDADIR/libida.so $out/lib
    cp $IDADIR/libida32.so $out/lib

    # Some libraries come with the installer.
    addAutoPatchelfSearchPath $IDADIR

    for bb in ida assistant; do
      wrapProgram $IDADIR/$bb \
        --prefix QT_PLUGIN_PATH : $IDADIR/plugins/platforms
      ln -s $IDADIR/$bb $out/bin/$bb
    done

    # runtimeDependencies don't get added to non-executables, and openssl is needed
    #  for cloud decompilation
    patchelf --add-needed libcrypto.so $IDADIR/libida.so


    runHook postInstall
  '';
}
