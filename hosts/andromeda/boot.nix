{pkgs, ...}: {
  # Bootloader.
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      limine = {
        enable = true;
        biosDevice = "nodev";
        efiSupport = true;
        secureBoot.enable = true;
      };
    };
    # initrd.luks = {
    #   devices.cryptroot.device = "/dev/disk/by-uuid/a2328a78-e2ba-4418-b4ee-b2c8dc839116";
    # }; # I'll do this later as I need to wipe all of my data to encrypt the whole root partition
    kernelPackages = pkgs.linuxPackages_latest;
  };

  environment.systemPackages = [
    pkgs.sbctl # Needed for secure boot
    pkgs.cryptsetup
  ];
}
