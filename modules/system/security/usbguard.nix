{...}: {
  services.usbguard = {
    enable = false;
    dbus.enable = true;
    rules = ''
      device_id "*:*"
    '';
  };
}
