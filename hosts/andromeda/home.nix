# Home Manager configuration for andromeda (main workstation).
#
# A machine enables capabilities by importing the matching category under
# ../../home. Andromeda gets everything, including modding (IDA Pro) and
# electronics (ModelSim/FPGA/STM32).
{...}: {
  imports = [
    ../../home/common.nix # shared Home Manager core
    ../../home/base
    ../../home/desktop
    ../../home/development
    ../../home/modding # IDA Pro + reversing
    ../../home/electronics # ModelSim, FPGA, STM32, KiCad
    ../../home/gaming
    ../../home/media
    ../../home/apps
  ];
}
