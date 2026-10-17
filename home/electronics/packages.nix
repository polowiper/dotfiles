# FPGA, STM32/embedded and electronics tooling.
{
  pkgs,
  lib,
  ...
}: let
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
  home.packages = with pkgs; [
    # STM32
    stm32cubemx
    stm32loader
    stlink
    stlink-tool
    (lib.lowPrio gcc-arm-embedded)
    (lib.lowPrio openocd)
    screen
    picocom
    platformio-core

    # FPGA / electronics
    graphviz
    yosys
    quartusPrimeLite
    openfpgaloader
    picoscope
    kicad
    gnuplot
  ];
}
