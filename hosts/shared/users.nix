{
  pkgs,
  config,
  ...
}: {
  users = {
    mutableUsers = true;
    users.${config.var.userName} = {
      isNormalUser = true;
      description = "${config.var.userFullName}";
      extraGroups = [
        "networkmanager"
        "kvm" # Android
        "adbusers" # Android
        "wheel"
        "libvirtd" # Qemu iirc ?
        "pico" # picoscope
        "dialout" # STM32
        "tty" # STM32
      ];
      shell = pkgs.fish;
    };
  };

  programs.fish = {
    enable = true;
  };
  programs.hyprland = {
    enable = true;
  };
}
