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
  nix = {
    #Storage optimization wizard things
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      cores = 6;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 20d --delete-old";
    };

    #Automatically gc when there is less than 5Gib of space left
    extraOptions = ''
      min-free = ${toString (5 * 1024 * 1024 * 1024)}
    '';
  };
  # OOM configuration (yes my pc is that bad):
  systemd = {
    # Create a separate slice for nix-daemon that is
    # memory-managed by the userspace systemd-oomd killer
    slices."nix-daemon".sliceConfig = {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "70%";
    };
    services."nix-daemon".serviceConfig.Slice = "nix-daemon.slice";

    # If a kernel-level OOM event does occur anyway,
    # strongly prefer killing nix-daemon child processes
    services."nix-daemon".serviceConfig.OOMScoreAdjust = 1000;
  };
}
