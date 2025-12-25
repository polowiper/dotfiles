{pkgs, config, ...}: {
  users = {
    mutableUsers = true;
    users.${config.var.userName} = {
      isNormalUser = true;
      description = "${config.var.userFullName}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
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
