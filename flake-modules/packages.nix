# Standalone packages extracted from home/. They can be built on their own:
#   nix build .#ida-pro
#   nix build .#modelsim
#
# `perSystem`'s default `pkgs` disallows unfree packages, so import nixpkgs
# explicitly with `allowUnfree` (IDA and the Hex-Rays servers are unfree).
{inputs, ...}: {
  perSystem = {system, ...}: let
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    packages.ida-pro = pkgs.callPackage ../pkgs/ida-pro {
      python3 = pkgs.python314;
    };
    packages.modelsim = pkgs.callPackage ../pkgs/modelsim/modelsim-wrappers.nix {};
  };
}
