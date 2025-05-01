{pkgs, ...}:
# In this file, we have hardware acceleration, bluetooth & tmpfs for /tmp
{
  hardware = {
    # Hardware acceleration.
    # This is for my old Dell laptop from 2011, with the Sandybridge processor.
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    enableRedistributableFirmware = true;

    # Enable & configure BT.
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        FastConnectable = true;
        JustWorksRepairing = "always";
        Experimental = true; # Battery info for Bluetooth devices
      };
    };
  };

  # Laptop's fan go brrrr.
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
}
