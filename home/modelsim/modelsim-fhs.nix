{pkgs ? import <nixpkgs> {}}:
# Layer 2: FHS Environment Wrapper
# Wraps the extracted ModelSim in a Filesystem Hierarchy Standard (FHS) environment
let
  # Layer 1: Get the extracted ModelSim
  modelsimExtracted = pkgs.callPackage ./modelsim-extract.nix {};

  modelsimBase = "${modelsimExtracted}/20.1/modelsim_ase";
in
  pkgs.buildFHSEnv {
    name = "modelsim";
    inherit (pkgs) pkgs;

    targetPkgs = pkgs:
      with pkgs; [
        glibc
        gcc
        zlib
        libX11
        libXext
        libXrender
        libXft
        fontconfig
        bash
        coreutils
        findutils
        gdb
        strace
        less
        file
        perl
      ];

    multiPkgs = pkgs:
      with pkgs;
        [
          glibc
          gcc.cc.lib
          zlib
          libX11
          libXext
          libXrender
          libXft
          fontconfig
        ]
        ++ (with pkgs.pkgsi686Linux; [
          glibc
          gcc.cc.lib
          zlib
          libX11
          libXext
          libXrender
          libXft
          fontconfig
        ]);

    runScript = pkgs.writeScript "modelsim-wrapper" ''
      #!/bin/bash

      MODELSIM_BASE="${modelsimBase}"

      if [ ! -d "$MODELSIM_BASE" ]; then
        echo "Error: ModelSim installation not found at $MODELSIM_BASE"
        exit 1
      fi

      export PATH="$MODELSIM_BASE/bin:$PATH"
      export LD_LIBRARY_PATH="/lib32:/lib32/glibc-*/lib:$MODELSIM_BASE/linux:$LD_LIBRARY_PATH"
      export MODELSIM_INSTALL="$MODELSIM_BASE"
      export SALT_LICENSE_SERVER="''${SALT_LICENSE_SERVER:-1700@localhost}"

      if [ $# -eq 0 ]; then
        echo "=== ModelSim FHS Environment ==="
        echo "ModelSim installation: $MODELSIM_BASE"
        echo ""
        echo "Available commands: vsim, vcom, vlog, vlib, vmap, vdel"
        echo "Type 'exit' to leave"
        echo ""
        bash
      else
        bash -c "exec $(printf '%q ' "$@")"
      fi
    '';

    meta = {
      description = "ModelSim FPGA simulator in FHS environment";
      longDescription = ''
        ModelSim wrapped in a Filesystem Hierarchy Standard (FHS) environment.
        Allows pre-compiled ModelSim binaries to run on NixOS.
      '';
    };
  }
