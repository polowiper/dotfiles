{...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      FastConnectable = true;
      JustWorksRepairing = "always";
      Experimental = true; # Battery info for Bluetooth devices
    };
  };
}
