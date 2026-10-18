# Re-exposes the two heavy self-contained programs from their own flakes.
#
# IDA Pro and ModelSim used to be vendored under ../pkgs/ along with their
# multi-hundred-MB vendor installers (<name>.run). They now live in dedicated
# flakes, declared as the `ida-pro` and `modelsim` inputs in ../flake.nix, so
# this repository only pins them and re-exports the packages for convenience:
#
#   nix build .#ida-pro
#   nix build .#modelsim
{inputs, ...}: {
  perSystem = {system, ...}: {
    packages.ida-pro = inputs.ida-pro.packages.${system}.ida-pro;
    packages.modelsim = inputs.modelsim.packages.${system}.modelsim;
  };
}
