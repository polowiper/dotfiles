{
  stdenv,
  fetchurl,
  buildFHSEnv,
  glibc,
  gcc,
  lib,
  xorg,
  zlib,
  fontconfig,
  perl,
}:
# Layer 1: Extract ModelSim from official .run installer
# Runs extraction in an FHS environment to provide all necessary libraries
let
  # FHS environment for running the installer
  extractEnv = buildFHSEnv {
    name = "modelsim-extract-env";
    inherit stdenv;

    targetPkgs = pkgs:
      with pkgs; [
        glibc
        gcc
        zlib
        xorg.libX11
        xorg.libXext
        xorg.libXrender
        xorg.libXft
        fontconfig
        bash
        coreutils
        perl
      ];

    multiPkgs = pkgs:
      with pkgs;
        [
          glibc
          gcc.cc.lib
          zlib
          xorg.libX11
          xorg.libXext
          xorg.libXrender
          xorg.libXft
          fontconfig
        ]
        ++ (with pkgs.pkgsi686Linux; [
          glibc
          gcc.cc.lib
          zlib
          xorg.libX11
          xorg.libXext
          xorg.libXrender
          xorg.libXft
          fontconfig
        ]);

    runScript = "bash";
  };
in
  stdenv.mkDerivation {
    pname = "modelsim-ase";
    version = "20.1.1.720";

    src = fetchurl {
      url = "https://download.altera.com/akdlm/software/acdsinst/20.1std.1/720/ib_installers/ModelSimSetup-20.1.1.720-linux.run";
      sha256 = "kUyRbya2uIZEAagvfa5Z2SCU86vQp7CJRurhbTraD7M=";
    };

    nativeBuildInputs = [];
    buildInputs = [];

    phases = ["installPhase"];

    installPhase = ''
      mkdir -p $out

      # Copy the installer
      INSTALLER="$(pwd)/installer.run"
      cp $src "$INSTALLER"
      chmod +x "$INSTALLER"

      # Run extraction within FHS environment
      ${extractEnv}/bin/modelsim-extract-env << EXTRACT_SCRIPT
        mkdir -p /tmp/ms_extract
        "$INSTALLER" \
          --mode unattended \
          --installdir /tmp/ms_extract \
          --accept_eula 1 \
          --unattendedmodeui none

        # The installer creates different directory structures depending on version
        # Check various possibilities
        if [ -d /tmp/ms_extract/20.1/modelsim_ase ]; then
          echo "Found at: /tmp/ms_extract/20.1/modelsim_ase"
          mkdir -p ${builtins.placeholder "out"}/20.1
          cp -r /tmp/ms_extract/20.1/modelsim_ase ${builtins.placeholder "out"}/20.1/
        elif [ -d /tmp/ms_extract/modelsim_ase ]; then
          echo "Found at: /tmp/ms_extract/modelsim_ase"
          mkdir -p ${builtins.placeholder "out"}/20.1
          cp -r /tmp/ms_extract/modelsim_ase ${builtins.placeholder "out"}/20.1/
        else
          echo "Error: ModelSim ASE directory not found"
          ls -la /tmp/ms_extract/
          exit 1
        fi

        chmod +x ${builtins.placeholder "out"}/20.1/modelsim_ase/bin/*
      EXTRACT_SCRIPT

      # Verify
      if [ ! -d "$out/20.1/modelsim_ase" ]; then
        echo "Error: Extraction failed"
        exit 1
      fi

      # Clean up
      rm -rf $out/logs
      rm -rf $out/uninstall

      echo "Successfully extracted ModelSim ASE"
    '';
  }
