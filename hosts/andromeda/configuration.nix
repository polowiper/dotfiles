# Andromeda: the main/gaming + reverse-engineering machine.
{...}: let
  inherit (import ./options.nix) stateVersion;
in {
  imports = [
    # Include the results of the hardware scan.
    ./boot.nix
    ./hardware-configuration.nix
    ./settings.nix

    # Shared system modules, opt-in per machine.
    ../../modules/system/core
    ../../modules/system/desktop
    ../../modules/system/desktop/gnome.nix
    ../../modules/system/hardware/fingerprint.nix
    ../../modules/system/hardware/udev.nix
    ../../modules/system/virt/libvirt.nix
    ../../modules/system/gaming/steam.nix
    ../../modules/system/security/mullvad.nix
    ../../modules/system/security/usbguard.nix
    ../../modules/system/security/openssh.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data were taken. Leave it at the release version
  # of the first install of this system.
  system.stateVersion = "${stateVersion}"; # Did you read the comment?
}
