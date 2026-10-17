{ pkgs ? import <nixpkgs> {} }:

# Optional convenience wrapper
# Allows testing the extraction + FHS layers without home-manager
# Usage: nix-build default.nix && ./result/bin/modelsim vsim -version

pkgs.callPackage ./modelsim-fhs.nix {}
