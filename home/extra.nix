{
  pkgs,
  lib,
  inputs,
  ...
}: let
  # pwndbg's flake applies a Darwin-only overlay through the deprecated
  # `stdenv.isDarwin` alias, and its build helpers read the deprecated
  # `stdenv.isDarwin`/`stdenv.isLinux` aliases. Re-expose those aliases from
  # `hostPlatform` and instantiate the package directly so that evaluating it
  # no longer prints deprecation warnings.
  hostAliases = [
    "isDarwin"
    "isLinux"
    "isSunOS"
    "isCygwin"
    "isBSD"
    "isFreeBSD"
    "isOpenBSD"
    "isi686"
    "isx86_32"
    "isx86_64"
    "is32bit"
    "is64bit"
    "isAarch32"
    "isAarch64"
    "isMips"
    "isBigEndian"
  ];
  fixStdenv = s:
    s
    // builtins.listToAttrs (
      map (name: {
        inherit name;
        value = builtins.getAttr name s.hostPlatform;
      })
      hostAliases
    )
    // {
      override = args: fixStdenv (s.override args);
    };
  # pwndbg 8.0.0 ships a capstone sdist that unconditionally builds a
  # `fuzz_disasm` target which does not link. Patch the target out of the
  # default build until it is fixed upstream.
  pwndbgCapstonePatch = pkgs.writeText "pwndbg-capstone-fuzz.patch" (
    builtins.concatStringsSep "\n" [
      "--- a/nix/pyenv.nix"
      "+++ b/nix/pyenv.nix"
      "@@ -207,6 +207,13 @@"
      "           nativeBuildInputs = old.nativeBuildInputs ++ ["
      "             cmake"
      "           ];"
      "+          # capstone's sdist unconditionally adds a `fuzz_disasm` executable"
      "+          # that does not link without a libFuzzer main. Keep it out of the"
      "+          # default build target."
      "+          postPatch = (old.postPatch or \"\") + ''"
      "+            substituteInPlace src/CMakeLists.txt \\"
      "+              --replace-fail 'add_executable(fuzz_disasm ' 'add_executable(fuzz_disasm EXCLUDE_FROM_ALL '"
      "+          '';"
      "         }"
      "       )"
      "     ) { };"
      ""
    ]
  );
  pwndbgSrc = pkgs.applyPatches {
    name = "pwndbg-patched";
    src = inputs.pwndbg.outPath;
    patches = [pwndbgCapstonePatch];
  };
  pwndbg = import "${pwndbgSrc}/nix/pwndbg.nix" {
    pkgs = pkgs.extend (_final: prev: {stdenv = fixStdenv prev.stdenv;});
    inputs =
      inputs.pwndbg.inputs
      // {
        self = pwndbgSrc;
      };
    groups = ["gdb"];
  };

  # TEMPORARY WORKAROUND (alpine-builder is down): Intel retired the Quartus
  # 25.1 download URLs, so the installer sources can't be fetched right now.
  # Reuse the unwrapped Quartus that is already built in the local store so only
  # the FHS wrapper has to be rebuilt. Remove this (and restore the plain
  # `quartus-prime-lite`) once alpine-builder is back and can substitute the
  # original installers.
  quartusUnwrapped =
    pkgs.runCommand "quartus-prime-lite-unwrapped-25.1std.0.1129"
    {
      inherit (pkgs.quartus-prime-lite.unwrapped) version meta;
    }
    "ln -s /nix/store/hr06sbdnxs23inm8xyjhi4z69axnzglm-quartus-prime-lite-unwrapped-25.1std.0.1129 $out";
  # The FHS wrapper links its icon through `unwrapped`, which the shim above
  # cannot provide to the build sandbox, so `pkgs.buildEnv` reports a dangling
  # symlink. Drop that icon link; the rest of the wrapper is unaffected.
  quartusPackage =
    builtins.replaceStrings
    ["ln -s \${unwrapped}/quartus/adm/quartusii.png $out/share/icons/hicolor/64x64/apps/quartus.png"]
    [""]
    (builtins.readFile "${pkgs.path}/pkgs/by-name/qu/quartus-prime-lite/package.nix");
  quartusPrimeLite =
    pkgs.callPackage "${pkgs.writeText "quartus-prime-lite-package.nix" quartusPackage}"
    {unwrapped = quartusUnwrapped;};
in {
  nixpkgs.config.android_sdk.accept_license = true;
  home.packages = with pkgs; [
    osu-lazer

    vial
    chromium # Only for webhid purposes I use firefox otherwise
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
    networkmanager-libreswan

    #Fpga card
    graphviz
    yosys
    quartusPrimeLite
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
    letos

    #Modding
    binutils
    hcli
    scrcpy
    android-tools
    apktool
    ghex
    httptoolkit-server
    httptoolkit
    wireshark
    ripgrep
    pwndbg
    unicorn
    capstone
    # python3Packages.qiling
    gdb

    # Poc (for serious programming I use devshells
    python311
    python311Packages.dbus-python
    libgcc
    gnumake
    lazygit

    #Gnome shi
    gradia

    kicad
    scilab-bin
    zathura
    texliveSmall
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
    nwg-displays
    slurp
    mpv-unwrapped

    # Coding ish stuff (I say ish because most of the coding shit is in devshells)
    man
    man-pages
    clang-manpages

    nix-inspect
    nix-prefetch-scripts
  ];
}
