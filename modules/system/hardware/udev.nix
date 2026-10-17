# Device-specific udev rules: Logitech G920 wheel, ST-Link/VIA/Vial keyboards
# and the Intel/Altera USB-Blaster (DE10-Lite).
{pkgs, ...}: {
  # Logitech G920 compat
  environment.etc = {
    "usb_modeswitch.d/046dc261" = {
      text = ''
        # Logitech G920 Racing Wheel
        DefaultVendor=046d
        DefaultProduct=c261
        MessageEndpoint=01
        ResponseEndpoint=01
        TargetClass=0x03
        MessageContent="0f00010142"
      '';
    };
  };

  # stlink for the DE10/STM32 tooling; via/vial need hidraw access so their
  # WebHID clients can talk to VIA/Vial keyboards (else /dev/hidraw* is 0600 root).
  services.udev.packages = [
    pkgs.stlink
    pkgs.via
    pkgs.vial
  ];
  services.udev.extraRules = ''
    ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c261", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -c /etc/usb_modeswitch.d/046dc261"
    # Intel / Altera USB-Blaster (DE10-Lite)
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6001", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6002", MODE="0666"
    ATTRS{idVendor}=="0ce9", MODE="777"

  '';
}
