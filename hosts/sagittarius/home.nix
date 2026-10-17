# Home Manager configuration for sagittarius (development laptop).
#
# A machine enables capabilities by importing the matching category under
# ../../home. This machine is the lean developer setup: no modding/gaming.
# Add `../../home/modding`, `../../home/electronics` or `../../home/gaming`
# below to enable those here.
{...}: {
  imports = [
    ../../home/common.nix # shared Home Manager core
    ../../home/base
    ../../home/desktop
    ../../home/development
    ../../home/media
    ../../home/apps
  ];
}
