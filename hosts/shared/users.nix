{pkgs, ...}: let
  inherit (import ../../home/options.nix) userName userFullName;
in {
  users = {
    mutableUsers = true;
    users.${userName} = {
      isNormalUser = true;
      description = "${userFullName}";
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
