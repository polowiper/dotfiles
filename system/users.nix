{inputs, pkgs, ...}:

let 
  inherit (import ../home/options.nix) userName userFullName;
in {
  users = {
    mutableUsers = true;
    users.${userName} = {
      isNormalUser = true;
      description = "${userFullName}";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.nushell; 
};
  };

programs.hyprland = {
  enable = true;
  package = inputs.hyprland.packages.${pkgs.system}.hyprland;
};
}
