# Power management: upower for the bar's battery module, TLP profiles.
{...}: {
  services.upower.enable = true; # Dependency for Hyprpanel's battery module

  services.power-profiles-daemon.enable = false; # Conflicts with tlp
  services.tlp = {
    enable = true;
    settings = {
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
    };
  };
}
