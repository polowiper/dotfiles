# Nix daemon tuning, GC, nh, nix-ld and the nix-daemon OOM policy.
{pkgs, ...}: {
  hardware.enableRedistributableFirmware = true;

  # Laptop's fan go brrrr.
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  nix = {
    # Storage optimization wizard things
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      cores = 6;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 20d --delete-old";
    };

    # Automatically gc when there is less than 5GiB of space left
    extraOptions = ''
      min-free = ${toString (5 * 1024 * 1024 * 1024)}
    '';
  };

  # Configure nh (nix helper)
  programs.nh = {
    enable = true;
    clean.enable = false;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];
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
