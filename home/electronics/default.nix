{...}: {
  imports = [
    ./modelsim.nix
    ./packages.nix
  ];

  # Enable ModelSim FPGA simulator with default configuration.
  programs.modelsim.enable = true;
}
