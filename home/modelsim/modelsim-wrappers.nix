{pkgs ? import <nixpkgs> {}}: let
  modelsimExtracted = pkgs.callPackage ./modelsim-extract.nix {};

  modelsimBase = "${modelsimExtracted}/20.1/modelsim_ase";

  modelsimFhs = pkgs.callPackage ./modelsim-fhs.nix {};

  mkWrapper = name:
    pkgs.writeShellScriptBin name ''
      exec ${modelsimFhs}/bin/modelsim ${modelsimBase}/bin/${name} "$@"
    '';
in
  pkgs.symlinkJoin {
    name = "modelsim";
    paths = map mkWrapper [
      "vsim"
      "vcom"
      "vlog"
      "vlib"
      "vmap"
      "vdel"
    ];

    meta = {
      description = "ModelSim FPGA simulator - individual command wrappers";
      longDescription = ''
        ModelSim binaries wrapped as individual commands in PATH.
        Includes: vsim, vcom, vlog, vlib, vmap, vdel

        All necessary libraries and environment variables are set up automatically.
      '';
      platforms = ["x86_64-linux"];
      license = "unfree";
    };
  }
